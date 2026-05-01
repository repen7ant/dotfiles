#
# ~/.bashrc
#
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

export JAVA_HOME="/usr/lib/jvm/default"
export EDITOR=nvim
export PATH="$PATH:/home/ilya/.local/bin:$HOME/scripts"

eval "$(starship init bash)"
eval "$(zoxide init bash)"

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s 2>/dev/null)" >/dev/null 2>&1
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

fastfetch

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
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
