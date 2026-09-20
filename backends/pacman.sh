# pacman backend (Arch, EndeavourOS, Manjaro, ...)
# Interface: BACKEND_HINT, BACKEND_CACHE_TTL, backend_packages, backend_groups,
#            backend_group_members, backend_install

BACKEND_HINT="sudo pacman -Syu"
BACKEND_CACHE_TTL=0

backend_packages()      { pacman -Slq 2>/dev/null | sort -u; }
backend_groups()        { pacman -Sgq 2>/dev/null | sort -u; }
backend_group_members() { pacman -Sgq "$1" 2>/dev/null; }

backend_install() {
    local -a cmd=("${SUDO[@]}" pacman -S --needed)
    (( ASSUME_YES )) && cmd+=(--noconfirm)
    run_or_print "${cmd[@]}" "$@"
}
