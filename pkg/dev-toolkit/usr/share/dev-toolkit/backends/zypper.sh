# zypper backend (openSUSE Leap / Tumbleweed, SLE)
# The package list is slow to build, so it is cached for 6 hours.

BACKEND_HINT="sudo zypper refresh"
BACKEND_CACHE_TTL=21600

backend_packages() {
    zypper --quiet --no-refresh search --type package 2>/dev/null \
        | awk -F'|' 'NF >= 3 { gsub(/^ +| +$/, "", $2); if ($2 != "" && $2 != "Name") print $2 }' \
        | sort -u
}
backend_groups()        { :; }
backend_group_members() { :; }

# Names starting with "@" are patterns (installed with "zypper install -t pattern").
backend_install() {
    local x
    local -a patterns=() pkgs=() yes=()
    for x in "$@"; do
        if [[ $x == @* ]]; then patterns+=("${x#@}"); else pkgs+=("$x"); fi
    done
    (( ASSUME_YES )) && yes=(-y)
    if (( ${#patterns[@]} )); then run_or_print "${SUDO[@]}" zypper install "${yes[@]}" -t pattern "${patterns[@]}"; fi
    if (( ${#pkgs[@]} ));     then run_or_print "${SUDO[@]}" zypper install "${yes[@]}" "${pkgs[@]}"; fi
    return 0
}
