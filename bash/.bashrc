#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"

export JAVA_HOME="/usr/lib/jvm/default"

eval "$(starship init bash)"

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s 2>/dev/null)" >/dev/null 2>&1
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

export EDITOR=nvim

fastfetch

export PATH="$PATH:/home/ilya/.local/bin:$HOME/scripts"

function setwall {
    if [ -z "$1" ]; then
        echo "to use: setwall <file>"
        return 1
    fi

    case "$1" in
    /* | ~/*) local WALL="$1" ;;
    *) local WALL="$HOME/walls/$1" ;;
    esac

    if [ ! -f "$WALL" ]; then
        echo "file not found: $WALL"
        return 1
    fi

    local FILENAME=$(basename "$WALL")
    xwallpaper --zoom "$WALL"
    betterlockscreen -u "$WALL"
    sed -i "s|xwallpaper --zoom .*|xwallpaper --zoom $WALL|" "$HOME/.xinitrc"
    echo "wallpaper changed: $FILENAME"
}

function wallpick {
    local walls_dir="$HOME/walls"
    local selected
    selected=$(
        ls "$walls_dir" | fzf \
            --preview "printf '\e_Ga=d\e\\'; chafa --size=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES} '$walls_dir/{}'" \
            --preview-window="right:60%"
    )
    printf '\e_Ga=d\e\\'
    [ -n "$selected" ] && setwall "$selected"
}

function proj {
    local git_dir="$HOME/git"
    local selected

    selected=$(ls "$git_dir" | fzf --preview "ls $git_dir/{}")
    [ -n "$selected" ] && y "$git_dir/$selected"
}

function wifi {
    nmcli device wifi rescan 2>/dev/null
    sleep 2

    local list
    list=$(nmcli -f SSID,SIGNAL,SECURITY device wifi list | tail -n +2)

    local selected_line
    selected_line=$(echo "$list" | fzf --prompt="wifi> ")
    [ -z "$selected_line" ] && return 1

    local line_num
    line_num=$(echo "$list" | grep -nF "$selected_line" | head -1 | cut -d: -f1)

    local ssid
    ssid=$(nmcli -t -f SSID device wifi list | tail -n +1 | sed -n "${line_num}p")

    nmcli connection up "$ssid" 2>/dev/null || echo "can't connect to $ssid"
}
