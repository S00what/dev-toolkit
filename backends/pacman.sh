# pacman backend (Arch, EndeavourOS, Manjaro, ...)
# Interface: BACKEND_HINT, BACKEND_CACHE_TTL, backend_packages, backend_groups,
#            backend_group_members, backend_install

BACKEND_HINT="sudo pacman -Syu"
BACKEND_CACHE_TTL=0

backend_packages()      { pacman -Slq 2>/dev/null | sort -u; }
backend_groups()        { pacman -Sgq 2>/dev/null | sort -u; }
backend_group_members() { pacman -Sgq "$1" 2>/dev/null; }

# Names starting with "aur:" are built with the AUR helper (yay or paru).
# That step is always interactive, so the recipes can be reviewed before building.
backend_install() {
    local x
    local -a repo=() aur=() cmd=("${SUDO[@]}" pacman -S --needed)
    for x in "$@"; do
        if [[ $x == aur:* ]]; then aur+=("${x#aur:}"); else repo+=("$x"); fi
    done
    (( ASSUME_YES )) && cmd+=(--noconfirm)
    if (( ${#repo[@]} )); then run_or_print "${cmd[@]}" "${repo[@]}" || return $?; fi
    if (( ${#aur[@]} ));  then run_or_print "$AUR_HELPER" -S --needed "${aur[@]}" || return $?; fi
    return 0
}
