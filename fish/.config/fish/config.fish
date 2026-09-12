source /usr/share/cachyos-fish-config/cachyos-config.fish
starship init fish | source

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
export PATH="$HOME/.local/bin:$PATH"
zoxide init fish | source

