#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#echo "$DIR"
#source "$DIR"/../docs/test-conf/test.conf
#source "$DIR"/../docs/test-conf/test-conf.sh
# source "$DIR"/new-vm-config.conf

# Identify current Desktop Environment
if [ "$XDG_CURRENT_DESKTOP" = "" ]; then
  desktop=$(echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/')
else
  desktop=$XDG_CURRENT_DESKTOP
fi

# Create .config directory
if [ ! -d ~/.config/new-vm-install ]; then
  mkdir -pv ~/.config/new-vm-install
fi

# Copy new-vm-config.conf to ~/.config directory and source it
cp --no-clobber "$DIR"/new-vm-config.conf ~/.config/new-vm-install
source ~/.config/new-vm-install/new-vm-config.conf
config_path="/home/$USER/.config/new-vm-install/new-vm-config.conf"

#desktop=${desktop,,}  # convert to lower case
echo "Desktop is $desktop, right?"

if [ -z "$pkg_mgr" ]; then
  # echo ""
  read -r -p "What package manager are you using, pacman or apt? " pkg_mgr 
  echo ""
fi

#read -r $pkg_mgr
#echo "$pkg_mgr"

if [ "$pkg_mgr" = 'pacman' ]; then
  # sed -i -e"s/^pkg_mgr=.*/pkg_mgr=$pkg_mgr/" "$DIR"/new-vm-config.conf
  sed -i -e"s/^pkg_mgr=.*/pkg_mgr=$pkg_mgr/" "$config_path"
  echo "You have selected $pkg_mgr as your package manager."
elif [ "$pkg_mgr" = 'apt' ]; then
  # sed -i -e"s/^pkg_mgr=.*/pkg_mgr=$pkg_mgr/" "$DIR"/new-vm-config.conf
  sed -i -e"s/^pkg_mgr=.*/pkg_mgr=$pkg_mgr/" "$config_path"
  echo "You have selected $pkg_mgr as your package manager."
fi

# echo "Just to confirm, your selected package manager is $pkg_mgr."

# Check if plank is installed
if [ "$pkg_mgr" = "apt" ]; then
  if dpkg -l plank 2>&1 | grep '^ii' > /dev/null; then
    plank_installed="y"
  fi
elif [ "$pkg_mgr" = "pacman" ]; then
  if pacman -Q plank >/dev/null 2>&1; then
    plank_installed="y"
  fi
fi
# exporting env variable...not sure if this is how I should do it?
export plank_installed