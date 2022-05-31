#!/usr/bin/env bash

# Install packages wanted and needed
echo "Installing packages" ;
sudo apt-get install -y -q=2 \
    arandr \
    autojump \
    blueman \
    cmake \
    curl \
    dunst \
    exa \
    flameshot \
    gdm3 \
    git \
    libnotify-bin \
    lxappearance \
    make \
    nautilus \
    neofetch \
    network-manager-gnome \
    nitrogen \
    numix-icon-theme-circle \
    papirus-icon-theme \
    polybar \
    psmisc \
    qt5-style-kvantum \
    qt5ct \
    ranger \
    rofi \
    rxvt-unicode \
    volumeicon-alsa \
    zip


# Install dependencies for picom
# https://github.com/ibhagwan/picom
echo "Installing packages for picom" ;
sudo apt-get install -y -q=2 \
    libconfig-dev \
    libdbus-1-dev \
    libev-dev \
    libevdev-dev \
    libgl1-mesa-dev \
    libpcre2-dev \
    libpcre3-dev \
    libpixman-1-dev \
    libx11-xcb-dev \
    libxcb-composite0-dev \
    libxcb-damage0-dev \
    libxcb-glx0-dev \
    libxcb-image0-dev \
    libxcb-present-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-render0-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libxcb-xinerama0-dev \
    libxcb1-dev \
    libxext-dev \
    uthash-dev

# Install dependecies for i3-gaps
# https://github.com/Airblader/i3
echo "Installing packages for i3-gaps" ;
sudo apt-get install -y -q=2 \
    dh-autoreconf \
    libev-dev \
    libpango1.0-dev \
    libstartup-notification0-dev \
    libxcb-cursor-dev \
    libxcb-icccm4-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-shape0 \
    libxcb-shape0-dev \
    libxcb-util0-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxcb-xrm-dev \
    libxcb-xrm0 \
    libxcb1-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libyajl-dev \
    meson \
    xcb

# Create missing directories
[ ! -d "$HOME/.config" ] && mkdir "$HOME/.config" ;
[ ! -d "$HOME/.config/gtk-2.0" ] && mkdir "$HOME/.config/gtk-2.0" ;
[ ! -d "$HOME/.local" ] && mkdir "$HOME/.local" ;
[ ! -d "$HOME/.local/share" ] && mkdir "$HOME/.local/share" ;
[ ! -d "$HOME/.local/share/applications" ] && mkdir "$HOME/.local/share/applications" ;
[ ! -d "$HOME/.local/bin" ] && mkdir "$HOME/.local/bin" ;
[ ! -d "$HOME/.themes" ] && mkdir "$HOME/.themes" ;
[ ! -d "$HOME/.icons" ] && mkdir "$HOME/.icons" ;
[ ! -d "$HOME/.local/share/fonts" ] && mkdir "$HOME/.local/share/fonts" ;
[ ! -d "/usr/share/xsessions" ] && sudo mkdir "/usr/share/xsessions" ;

# Create installing directory
[ ! -d "$HOME/installing" ] && mkdir "$HOME/installing"; cd ~/installing ;

# Build picom from source
echo "Building picom" ;
git clone -q https://github.com/ibhagwan/picom.git && 
cd picom &&
git submodule update --init --recursive &&
meson --buildtype=release . build &&
ninja -C build &&
cd build &&
sudo ninja install; 

# Cleanup
cd ~/installing && 
rm -rf picom;

# Build i3-gaps from source
echo "Building i3-gaps" ;
git clone -q https://github.com/Airblader/i3.git i3-gaps && 
cd i3-gaps &&
mkdir -p build && 
cd build && 
meson --prefix /usr/local && 
ninja && 
sudo ninja install ; 
[ ! -f "i3.desktop" ] && 
touch "i3.desktop" ;
cat > i3.desktop <<EOL
[Desktop Entry]
Name=i3
Comment=improved dynamic tiling window manager
Exec=i3
TryExec=i3
Type=Application
X-LightDM-DesktopName=i3
DesktopNames=i3
Keywords=tiling;wm;windowmanager;window;manager;
EOL

sudo mv i3.desktop /usr/share/xsessions ;

# Cleanup
cd ~/installing && 
rm -rf i3-gaps ;

# Installing google chrome
echo "Installing google chrome" ;
curl -s -L0 https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --output google-chrome-stable.deb &&
sudo apt-get install -y -q=2 ./google-chrome-stable.deb &&
sudo sed -i 's/chrome-stable/chrome-stable --force-dark-mode/g' /usr/share/applications/google-chrome.desktop &&
rm google-chrome-stable.deb ;

# Setting the theme from command line doesn't work with i3 and I'm too lazy
# to do the editing of the config file directly, so I'll set it manually
# with lxappearance

# Install Dracula theme for GTK
# https://github.com/matheuuus/dracula-theme
echo "Installing dracula theme" ;
curl -s -L0 https://github.com/dracula/gtk/archive/refs/heads/master.zip --output Dracula.zip &&
unzip -qq Dracula.zip &&
mv dracula-theme-master ~/.themes/Dracula && 
rm -rf Dracula.zip ;

# Install Dracula icons
# https://github.com/matheuuus/dracula-icons
echo "Installing dracula icons" ;
curl -s -L0 https://github.com/natperron/dracula-icons/archive/refs/heads/main.zip --output Dracula-icons.zip && 
unzip -qq Dracula-icons.zip &&
mv dracula-icons-main ~/.icons/Dracula && 
rm -rf Dracula-icons.zip ;
# Fix icons
sed -i 's/Inherits=/Inherits=Numix Circle,Papirus-Dark,/' ~/.icons/Dracula/index.theme &&
rm "$HOME/.icons/Dracula/scalable/apps/lutris.svg";

# Install fonts
# IPAExGothic (Japanese)
echo "Installing fonts" ;
sudo apt-get install -y -q=2 fonts-ipaexfont-gothic;
curl -s -L0 https://github.com/FortAwesome/Font-Awesome/archive/refs/heads/master.zip --output Font-Awesome.zip &&
unzip -qq Font-Awesome.zip && 
mv Font-Awesome-master/webfonts/*.ttf ~/.local/share/fonts/ &&
mv Font-Awesome-master/otfs/*.otf ~/.local/share/fonts/ &&
rm -rf Font-Awesome.zip &&
rm -rf Font-Awesome-master ;
curl -s -L0 https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Overpass.zip --output NerdFonts.zip &&
unzip -qq NerdFonts.zip &&
mv *.otf ~/.local/share/fonts/ && 
rm -rf NerdFonts.zip;

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
