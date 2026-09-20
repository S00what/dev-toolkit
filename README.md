# dev-toolkit

Set up a fresh Linux install for development in one go. Pick ready-made
toolkits, tweak the list with `add` / `del`, install everything at once.

Works on **pacman** (Arch and friends), **apt** (Debian, Ubuntu), **dnf** (Fedora)
and **zypper** (openSUSE). The package manager is detected automatically.

## Usage

    dev-toolkit                      # interactive
    dev-toolkit -t web,devops -y     # no questions
    dev-toolkit -n                   # dry run: print the install command only
    dev-toolkit -t all -n            # check which packages exist on this distro

Interactive flow: choose toolkits (several at once), then edit the list:

    > add telegram-desktop
    > del git
    > list
    > done

`add` checks the name right away. A typo is fixed automatically when the match is
close (`firefx -> firefox`), you are asked when it is a guess
(`Did you mean X? [Y/n]`), and unknown names are rejected.

## Toolkits

| Toolkit     | Contents                                   |
|-------------|--------------------------------------------|
| `base`      | git, curl, wget, compiler basics, vim (always installed) |
| `c`         | C / C++ / C# tools                         |
| `web`       | Node.js, TypeScript, esbuild, Sass, browsers |
| `editors`   | Vim, VS Code (open-source build), Cursor (AUR) |
| `devops`    | Docker, kubectl, Ansible, OpenTofu         |
| `highlevel` | Python, Ruby, Java, Go, Lua                |
| `terminal`  | tmux, fzf, ripgrep, jq, bat                |
| `db`        | SQLite, PostgreSQL, Redis                  |

## Customizing

* **New toolkit:** add `toolkits/<name>.list` (one package per line, Arch names,
  first line `# desc: ...`).
* **Another distro's names:** `maps/<backend>.map`, format `arch-name = native names`
  (`a b` several packages, `a|b` first that exists, `@x` group or pattern,
  `aur:x` AUR package, `!` not available on that package manager).
* **New package manager:** `backends/<name>.sh` (see `backends/apt.sh`).

## AUR (Arch)

Packages that are not in the official repositories (Cursor) are built with `yay`
or `paru` if one is installed; otherwise they are skipped with a note. You can also
type `add aur:<name>`. The AUR step is always interactive so you can review the
recipes before they are built, even with `-y`.

## Install

    make install PREFIX=/usr        # or use the PKGBUILD

## License

GPL-3.0-or-later
