#!/usr/bin/env bash

install_package(){
    local package="$1"
    if [[ $(command -v apt) ]]; then
        if [[ -n "$TERMUX_VERSION" ]]; then
            pkg install -y $package >/dev/null 2>&1 || echo -e "App not Installed"
        else
            sudo apt-get install -y $package 2>/dev/null || echo -e "App not Installed"
        fi
    elif [[ $(command -v pacman) ]]; then
        sudo pacman -S --noconfirm $package >/dev/null 2>&1 || echo -e "App not Installed"
    elif [[ $(command -v dnf) ]] ; then
        sudo dnf install -y $package 2>/dev/null || echo -e "App not Installed"
    fi
}

if ! [[ -d ~/.tmux ]] ; then 
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

sudo ls >/dev/null 2>&1
packages=("base-devel" "bash-completion" "bat" "curl" "gcc" "git" "lua-language-server" "make" "man-db" "man-pages" "neovim" "nodejs" "npm" "openssh" "ripgrep" "rsync" "unzip" "vim" "vi" "stylua" "tree" "tmux" "wget" "aria2" "python3")

for package in "${packages[@]}" ; do 
    printf "installing %s...\n" "$package"
    install_package $package
done

if [[ "$(uname -m)" = "x86_64" ]] ;then
    x86_64_packages=("blueman" "bluez-utils" "brightnessctl" "evince" "grim" "libnotify" "networkmanager" "pipewire" "pavucontrol" "pulseaudio" "slurp" "sudo" "thunar" "ttf-font-awesome" "otf-font-awesome" "wireplumber" "xclip" "yazi" "zenity")
    for package in "${x86_64_packages[@]}" ; do 
        printf "installing %s...\n" "$package"
        install_package $package
    done
fi

if [[ -n "$TERMUX_VERSION" ]]; then
    npm install -g tree-sitter-cli 2>/dev/null
else
    sudo npm install -g tree-sitter-cli 2>/dev/null
fi

read -p "Do you want to install hyprland configs? [Yes/No] -> " -n 4 val 
if [[ $val =~ ^[Yy][Ee][Ss]$ ]] ; then 
    hypr_packages=("hyprland" "kitty" "alacritty" "rofi" "waybar" "hypridle" "hyprlock" "hyprpaper" "swaync")
    for package in "${hypr_packages[@]}" ; do
        printf "installing %s...\n" "$package"
        install_package $package

        systemctl --user enable hyprpaper
        systemctl --user start hyprpaper
        systemctl --user enable hypridle
        systemctl --user start hypridle

    done
else
    echo "Installation Completed..."
fi

