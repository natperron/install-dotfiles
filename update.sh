# Personal dotfiles
echo "Installing personal dotfiles" ;
[ -d "$HOME/.config/bash" ] && rm -rf "$HOME/.config/bash" ;
[ -d "$HOME/.config/dunst" ] && rm -rf "$HOME/.config/dunst" ;
[ -d "$HOME/.config/flameshot" ] && rm -rf "$HOME/.config/flameshot" ;
[ -d "$HOME/.config/git" ] && rm -rf "$HOME/.config/git" ;
[ -d "$HOME/.config/i3" ] && rm -rf "$HOME/.config/i3" ;
[ -d "$HOME/.config/Kvantum" ] && rm -rf "$HOME/.config/Kvantum" ;
[ -d "$HOME/.config/neofetch" ] && rm -rf "$HOME/.config/neofetch" ;
[ -d "$HOME/.config/picom" ] && rm -rf "$HOME/.config/picom" ;
[ -d "$HOME/.config/polybar" ] && rm -rf "$HOME/.config/polybar" ;
[ -d "$HOME/.config/ranger" ] && rm -rf "$HOME/.config/ranger" ;
[ -d "$HOME/.config/rofi" ] && rm -rf "$HOME/.config/rofi" ;
[ -d "$HOME/.config/vim" ] && rm -rf "$HOME/.config/vim" ;
[ -d "$HOME/.config/volumeicon" ] && rm -rf "$HOME/.config/volumeicon" ;
[ -d "$HOME/.config/X11" ] && rm -rf "$HOME/.config/X11" ;
[ -f "$HOME/.config/user-dirs.dirs" ] && rm -rf "$HOME/.config/user-dirs.dirs" ;
[ -f "$HOME/.bashrc" ] && rm -rf "$HOME/.bashrc" ;
[ -f "$HOME/.profile" ] && rm -rf "$HOME/.profile" ;
git clone -q https://natperron@github.com/natperron/dotfiles.git &&
mv dotfiles/.config/* ~/.config/ && 
mv dotfiles/.bashrc ~/.bashrc && 
mv dotfiles/.profile ~/.profile && 
# mv dotfiles/.local/share/fonts/* ~/.local/share/fonts/ &&
mv dotfiles/.local/bin/* ~/.local/bin/ ;
rm -rf dotfiles && cd && rm -rf installing;
