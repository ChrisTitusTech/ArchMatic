#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

if ! source install.conf; then
	read -p "Please enter hostname:" hostname

	read -p "Please enter username:" username

	read -ps "Please enter password:" password

	read -sp "Please repeat password:" password2

	# Check both passwords match
	if [ "$password" != "$password2" ]; then
	    echo "Passwords do not match"
	    exit 1
	fi
  printf "hostname="$hostname"\n" >> "install.conf"
  printf "username="$username"\n" >> "install.conf"
  printf "password="$password"\n" >> "install.conf"
fi

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf

echo "-------------------------------------------------"
echo "                    Set locale                   "
echo "-------------------------------------------------"

echo -n "Do you want an American locale? Type anything to open nano to uncomment the desired locales. Otherwise the script will automatically set it to US: "
read desiredlocales
if [[ -z $desiredlocales ]]
then 
	nano /etc/locale.gen
else 
	sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
fi
locale-gen

## Let the user decide the timezone
echo -n "Which timezone do you want? For a list of working timezones type 'print'. The script will default to 'America/Chicago': "
read desiredtimezone
while [[ $desiredtimezone = print ]]
do
        timedatectl list-timezones|less
        echo -n "Which timezone do you want? For a list of working timezones type 'print'. The script will default to 'America/Chicago': "
        read desiredtimezone
done

if [[ -z $desiredtimezone ]]
then
        desiredtimezone=America/Chicago
fi

timedatectl --no-ask-password set-timezone $desiredtimezone
timedatectl --no-ask-password set-ntp 1

echo -n "Do you want to set a custom language? Recommended if you chose anything other than an american locale. This will automatically set to american english (en_US.UTF-8) if no input is provided. Type anything to open an editor to set the language: "
read desiredlocaletoset

if [[ -z $desiredlocaletoset ]]
then
	localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_COLLATE="" LC_TIME="en_US.UTF-8"
else
	nano /etc/locale.conf
fi


# Set keymaps
echo -n "Which keyboard layout do you want to use? type 'print' to show avalible layouts. This will default to an American layout us"
read desiredkeymap

while [[ $deisredkeymap = print ]]
do
	localectl list-keymaps|less
	echo -n "Which keyboard layout do you want to use? type 'print' to show avalible layouts. This will default to an American layout us"
	read desiredkeymap
done

if [[ -z $desiredkeymap ]]
then
	desiredkeymap=us
fi
localectl --no-ask-password set-keymap $desiredkeymap

# Hostname
hostnamectl --no-ask-password set-hostname $hostname

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

