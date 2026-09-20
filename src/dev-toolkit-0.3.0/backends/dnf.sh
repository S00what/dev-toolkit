# dnf backend (Fedora, RHEL and derivatives)
# The package list is slow to build, so it is cached for 6 hours.

BACKEND_HINT="sudo dnf makecache"
BACKEND_CACHE_TTL=21600

backend_packages()      { dnf repoquery -q --qf '%{name}\n' 2>/dev/null | sort -u; }
backend_groups()        { :; }
backend_group_members() { :; }

# Names starting with "@" are package groups (installed with "dnf group install").
backend_install() {
    local x
    local -a groups=() pkgs=() yes=()
    for x in "$@"; do
        if [[ $x == @* ]]; then groups+=("${x#@}"); else pkgs+=("$x"); fi
    done
    (( ASSUME_YES )) && yes=(-y)
    if (( ${#groups[@]} )); then run_or_print "${SUDO[@]}" dnf group install "${yes[@]}" "${groups[@]}"; fi
    if (( ${#pkgs[@]} ));   then run_or_print "${SUDO[@]}" dnf install "${yes[@]}" "${pkgs[@]}"; fi
    return 0
}
