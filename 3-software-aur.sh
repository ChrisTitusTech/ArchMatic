#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE\n"

cd "${HOME}"

echo "CLOING: YAY"
git clone "https://aur.archlinux.org/yay.git"


PKGS=(

    # UTILITIES -----------------------------------------------------------

    'i3lock-fancy'              # Screen locker
    'synology-drive'            # Synology Drive
    'freeoffice'                # Office Alternative
    
    # MEDIA ---------------------------------------------------------------

    'screenkey'                 # Screencast your keypresses
    'lbry-app-bin'              # LBRY Linux Application

    # COMMUNICATIONS ------------------------------------------------------

    'brave-nightly-bin'         # Brave
    

    # THEMES --------------------------------------------------------------

    'lightdm-webkit-theme-aether'   # Lightdm Login Theme - https://github.com/NoiSek/Aether#installation
    'materia-gtk-theme'             # Desktop Theme
    'papirus-icon-theme'            # Desktop Icons
    'capitaine-cursors'             # Cursor Themes
)


cd ${HOME}/yay
makepkg -si
# You can solove users running this script as root with this and then doing the same for the next for statement. Howerver I will leave this up to you.
#if [[ whoami = root  ]]
#then
#	useradd -M -G wheel tempuser
#	su tempuser -C 'echo "hello!"'
#	userdel tempuser
#else
#	makepkg -si
#fi


for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

echo -e "\nDone!\n"
