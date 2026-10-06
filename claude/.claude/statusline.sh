#!/usr/bin/env bash
input=$(cat)

IFS=$'\x1f' read -r dir worktree model effort cost ctx_in ctx_size ctx_pct hit_ratio cache_writes < <(
  jq -r '[
    (.workspace.current_dir // .cwd // ""),
    (.worktree.name // .workspace.git_worktree // ""),
    (.model.display_name // .model.id // ""),
    (.effort.level // ""),
    (.cost.total_cost_usd // 0),
    (.context_window.total_input_tokens // 0),
    (.context_window.context_window_size // 0),
    (.context_window.used_percentage // ""),
    (.prompt_cache.hit_ratio // ""),
    (.prompt_cache.cache_write_tokens // "")
  ] | map(tostring) | join("\u001f")' <<<"$input"
)


rgb() { printf '\033[38;2;%d;%d;%dm' "0x${1:0:2}" "0x${1:2:2}" "0x${1:4:2}"; }
c256() { printf '\033[38;5;%dm' "$1"; }
BG=$'\033[48;2;18;18;18m'
BG_AS_FG=$(rgb 121212)
FG_RESET=$'\033[39m'
RESET=$'\033[0m'
C_SEP=$(c256 244)
C_MODEL=$(rgb d787af)
C_PATH=$(rgb 00afaf)
C_GIT_CLEAN=$(rgb 5faf5f)
C_GIT_DIRTY=$(rgb d7af5f)
C_DIRTY=$(c256 178)
C_STAGED=$(c256 70)
C_UNTRACKED=$(c256 39)
C_CONTEXT=$(rgb 8787af)
C_SPEND=$(rgb 5fafaf)
C_COST=$(c256 205)
C_WARNING=$(rgb e4c00f)
C_ERROR=$(rgb fc3a4b)
C_PURPLE=$(rgb b281d6)
C_MUTED=$(rgb 777d88)

I_MODEL=$''
I_FOLDER=$''
I_WORKTREE=$''
I_BRANCH=$''
I_CONTEXT=$''
I_CACHE=$''
SEP=" ${C_SEP}"$''"${FG_RESET} "
CAP_LEFT=$''
CAP_RIGHT=$''

human() {
  awk -v n="$1" 'function f(v) { s = sprintf("%.1f", v); sub(/\.0$/, "", s); return s }
  BEGIN {
    if (n < 1000) printf "%d", n
    else if (n < 1e4) printf "%sK", f(n / 1e3)
    else if (n < 1e6) printf "%dK", int(n / 1e3 + 0.5)
    else if (n < 1e7) printf "%sM", f(n / 1e6)
    else printf "%dM", int(n / 1e6 + 0.5)
  }'
}

# Fish-style path: ~/D/w/m/c/s/repo
short_path() {
  local p="${1/#"$HOME"/\~}" out="" part
  local -a parts
  IFS=/ read -ra parts <<<"$p"
  local last=$((${#parts[@]} - 1))
  for i in "${!parts[@]}"; do
    part="${parts[$i]}"
    if ((i == last)); then
      out+="$part"
    elif [[ -z "$part" ]]; then
      out+="/"
    else
      [[ "$part" == .* ]] && out+="${part:0:2}/" || out+="${part:0:1}/"
    fi
  done
  printf '%s' "$out"
}

# Projects below ~/Developer/<root> show as <root>/..., abbreviated past 40 chars
display_path() {
  local root rel
  for root in work 0x41; do
    if [[ "$1" == "$HOME/Developer/$root" || "$1" == "$HOME/Developer/$root/"* ]]; then
      rel="$root${1#"$HOME/Developer/$root"}"
      if ((${#rel} > 40)); then
        rel="$root/$(short_path "${rel#"$root/"}")"
      fi
      printf '%s' "$rel"
      return
    fi
  done
  short_path "$1"
}

segments=()

# Model + effort
model="${model#Claude }"
seg="${C_MODEL}${I_MODEL} ${model}"
case "$effort" in
  low) seg+=" · "$'\U000F0A9F'" low" ;;
  medium) seg+=" · "$'\U000F0AA1'" med" ;;
  high) seg+=" · "$'\U000F0AA3'" high" ;;
  xhigh) seg+=" · "$'\U000F0AA5'" xhi" ;;
  max) seg+=" · "$''" max" ;;
esac
segments+=("${seg}${FG_RESET}")

# Path, or project/worktree when inside one
if [[ -n "$worktree" ]]; then
  root=$(git -C "$dir" --no-optional-locks rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
  project=$(basename "$(dirname "${root:-$dir}")")
  segments+=("${C_PATH}${I_WORKTREE} ${project}/${worktree}${FG_RESET}")
else
  segments+=("${C_PATH}${I_FOLDER} $(display_path "$dir")${FG_RESET}")
fi

# Git branch with unstaged/staged/untracked counts
if status=$(git -C "$dir" --no-optional-locks status --porcelain=v1 2>/dev/null); then
  read -r unstaged staged untracked < <(awk '
    /^\?\?/ { u++; next }
    { if (substr($0, 1, 1) != " ") s++; if (substr($0, 2, 1) != " ") d++ }
    END { printf "%d %d %d\n", d, s, u }' <<<"$status")
  branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
  [[ -z "$branch" ]] && branch=$(git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  counts=""
  ((unstaged > 0)) && counts+=" ${C_DIRTY}*${unstaged}"
  ((staged > 0)) && counts+=" ${C_STAGED}+${staged}"
  ((untracked > 0)) && counts+=" ${C_UNTRACKED}?${untracked}"
  color=$C_GIT_CLEAN
  [[ -n "$counts" ]] && color=$C_GIT_DIRTY
  segments+=("${color}${I_BRANCH} ${branch}${counts}${FG_RESET}")
fi

# Context: percentage of window size, with omp's thresholds (% or absolute tokens)
if [[ -n "$ctx_pct" ]]; then
  level=$(awk -v p="$ctx_pct" -v t="$ctx_in" 'BEGIN {
    if (p >= 90 || t >= 500000) print "error"
    else if (p >= 70 || t >= 270000) print "purple"
    else if (p >= 50 || t >= 150000) print "warning"
    else print "normal"
  }')
  case "$level" in
    error) color=$C_ERROR ;;
    purple) color=$C_PURPLE ;;
    warning) color=$C_WARNING ;;
    *) color=$C_CONTEXT ;;
  esac
  ctx_text="$(printf '%.1f' "$ctx_pct")%/$(human "$ctx_size")"
else
  color=$C_CONTEXT
  ctx_text=$(human "$ctx_size")
fi
segments+=("${C_CONTEXT}${I_CONTEXT} ${color}${ctx_text}${FG_RESET}")

# Prompt cache: session hit ratio and tokens written
if [[ -n "$hit_ratio" ]]; then
  hit=$(awk -v r="$hit_ratio" 'BEGIN { printf "%d", r * 100 + 0.5 }')
  if ((hit >= 80)); then color=$C_SPEND
  elif ((hit >= 50)); then color=$C_WARNING
  else color=$C_ERROR
  fi
  seg="${C_SPEND}${I_CACHE} ${color}${hit}%${FG_RESET}"
  [[ -n "$cache_writes" ]] && seg+="${C_MUTED} · $(human "$cache_writes") w${FG_RESET}"
  segments+=("$seg")
fi

segments+=("${C_COST}$(printf '$%.2f' "$cost")${FG_RESET}")

line="${BG_AS_FG}${CAP_LEFT}${BG} "
for i in "${!segments[@]}"; do
  ((i > 0)) && line+="$SEP"
  line+="${segments[$i]}"
done
line+=" ${RESET}${BG_AS_FG}${CAP_RIGHT}${RESET}"

printf '%s\n' "$line"
