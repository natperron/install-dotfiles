# Install packages wanted and needed
echo "Installing packages" ;
sudo apt-get install -y git make cmake curl zip ranger exa autojump nitrogen arandr psmisc dunst libnotify-bin lxappearance qt5ct qt5-style-kvantum nautilus flameshot rxvt-unicode volumeicon-alsa blueman network-manager-gnome neofetch polybar rofi gdm3 ; 

# Install dependencies for picom
# https://github.com/ibhagwan/picom
echo "Installing packages for picom" ;
sudo apt-get install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev ;

# Install dependecies for i3-gaps
# https://github.com/Airblader/i3
echo "Installing packages for i3-gaps" ;
sudo apt-get install -y meson dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0 libxcb-shape0-dev ;

# Create missing directories
[ ! -d "$HOME/.config" ] && mkdir "$HOME/.config" ;
[ ! -d "$HOME/.config/gtk-2.0" ] && mkdir "$HOME/.config/gtk-2.0" ;
[ ! -d "$HOME/.local" ] && mkdir "$HOME/.local" ;
[ ! -d "$HOME/.local/share" ] && mkdir "$HOME/.local/share" ;
[ ! -d "$HOME/.local/bin" ] && mkdir "$HOME/.local/bin" ;
[ ! -d "$HOME/.themes" ] && mkdir "$HOME/.themes" ;
[ ! -d "$HOME/.icons" ] && mkdir "$HOME/.icons" ;
[ ! -d "$HOME/.local/share/fonts" ] && mkdir "$HOME/.local/share/fonts" ;

# Create installing directory
[ ! -d "$HOME/installing" ] && mkdir "$HOME/installing"; cd ~/installing ;

# Build picom from source
echo "Building picom" ;
git clone https://github.com/ibhagwan/picom.git && 
cd picom &&
git submodule update --init --recursive &&
meson --buildtype=release . build &&
ninja -C build &&
cd build &&
sudo ninja install ; 

# Cleanup
cd ~/installing && 
rm -rf picom;

# Build i3-gaps from source
echo "Building i3-gaps" ;
git clone https://github.com/Airblader/i3.git i3-gaps && 
cd i3-gaps &&
mkdir -p build && 
cd build && 
meson --prefix /usr/local && 
ninja && 
sudo ninja install ; 
[ ! -f "/usr/share/xsessions/i3.desktop" ] && 
touch "/usr/share/xsessions/i3.desktop" ;
cat > /usr/share/xsessions/i3.desktop
<<EOL
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

# Cleanup
cd ~/installing && 
rm -rf i3-gaps ;

# Installing firefox developer edition
echo "Installing firefox developer edition" ;
curl -L0 https://download.mozilla.org/?product=firefox-develedition-latest-ssl&os=linux&lang=en-CA --output firefox.tar.bz2 &&
sudo mv firefox.tar.bz2 /opt &&
cd /opt &&
sudo tar xfj firefox.tar.bz2 &&
sudo rm -rf firefox.tar.bz2 &&
sudo chown -R $USER:$USER /opt/firefox && 
cd ~/installing ;
cat > ~/.local/share/applications/firefoxDeveloperEdition.desktop
<<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Developer Edition
Exec=/opt/firefox/firefox
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;Favorite;
MimeType=text/html;text/xml;application/xhtml/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp; X
X-Ayatana-Desktop-Shortcuts=NewWindow;NewIncognitos;
EOL

# Setting the theme from command line doesn't work with i3 and I'm too lazy
# to do the editing of the config file directly, so I'll set it manually
# with lxappearance

# Install Dracula theme for GTK
# https://github.com/matheuuus/dracula-theme
echo "Installing dracula theme" ;
curl -L0 https://github.com/matheuuus/dracula-theme/archive/refs/heads/master.zip --output Dracula.zip &&
unzip Dracula.zip &&
mv dracula-theme-master ~/.themes/Dracula && 
rm -rf Dracula.zip ;

# Install Dracula icons
# https://github.com/matheuuus/dracula-icons
echo "Installing dracula icons" ;
curl -L0 https://github.com/matheuuus/dracula-icons/archive/refs/heads/main.zip --output Dracula-icons.zip && 
unzip Dracula-icons.zip &&
mv dracula-icons-main ~/.icons/Dracula && 
rm -rf Dracula-icons.zip ;

# Install fonts
# IPAExGothic (Japanese)
echo "Installing Japanese font" ;
sudo apt-get install -y fonts-ipaexfont-gothic ;

# Font Awesome
echo "Installing Font-Awesome font"
curl -L0 https://github.com/FortAwesome/Font-Awesome/archive/refs/heads/master.zip --output Font-Awesome.zip &&
unzip Font-Awesome.zip && 
mv Font-Awesome-master/webfonts/*.ttf ~/.local/share/fonts/ &&
mv Font-Awesome-master/otfs/*.otf ~/.local/share/fonts/ &&
rm -rf Font-Awesome.zip &&
rm -rf Font-Awesome-master ;

# Nerd Font
echo "Installing Nerd font" ;
curl -L0 https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Overpass.zip --output NerdFonts.zip &&
unzip NerdFonts.zip &&
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
git clone https://natperron@github.com/natperron/dotfiles.git &&
mv dotfiles/.config/* ~/.config/ && 
mv dotfiles/.bashrc ~/.bashrc && 
mv dotfiles/.profile ~/.profile && 
# mv dotfiles/.local/share/fonts/* ~/.local/share/fonts/ &&
mv dotfiles/.local/bin/* ~/.local/bin/ ;
rm -rf dotfiles && cd && rm -rf installing;
