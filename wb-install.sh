#!/bin/bash

check () {

#  if [ $1 -eq 0 ]; then echo -e "[  Ok  ]" ; else echo -e "[ Fail ]" ; exit 1 ; fi
  if [ $1 -eq 0 ]; then echo -e "[  Ok  ]" ; else echo -e "[ Fail ]" ; fi

}

setup () {

  echo " 
  ~ * Setup the fast mirror and update system :
  "

  printf "%-80s" "Fast mirror"
  sudo pacman-mirrors --geoip &>/dev/null
  check $?

  printf "%-80s" "Update system"
  sudo pacman -Syyu --noconfirm &>/dev/null
  check $?

}

install_pac () {

  echo " 
  ~ * Installing apps with pacman Stage :
  "

  declare -a APPS=(
    alacritty
    arandr
    i3-gaps
    brave
    firefox
    ttf-fira-code
    blueman
    arc-gtk-theme
    cmatrix
    cowsay
    feh
    git
    zsh
    python-pywal
  )

  for APP in ${APPS[@]}; do
    if [[ $(pacman -Qs $APP | grep Nome | wc -l) -eq 0 ]]; then
      printf "
      %-80s" "Install - $APP"
      sudo pacman -S $APP --noconfirm &>/dev/null
      check $?
    fi
  done

  printf "%-80s" "Install - Oh my zsh"
  n | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &>/dev/null
  check $?

}

install_yay () {
  
  echo " 
  ~ * Installing apps with yay Stage :
  "

  declare -a YAY=(
    ttf-font-awesome-4
    ttf-fira-code
    visual-studio-code-bin
    alacritty-themes
  )

  for Y in ${YAY[@]}; do
    printf "
    %-80s" "Install - $Y"
    yay -S $Y --noconfirm &>/dev/null
    check $?
  done

}

install_plugins () {

  printf "%-80s" "Install - zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &>/dev/null
  check $?

  printf "%-80s" "Install - zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &>/dev/null
  check $?

  printf "%-80s" "Install - Power Level 10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &>/dev/null
  check $?

}

configuraterc () {

  echo " 
  ~ * Configurations Stage :
  "

  printf "%-80s" "Set alacritty"
  mkdir ~/.config/alacritty
  sudo cp -r ./configs/alacritty.yml ~/.config/alacritty/alacritty.yml &>/dev/null
  check $?

  printf "%-80s" "Set i3 conf"
  sudo cp -r ./configs/i3-config ~/.i3/config &>/dev/null
  check $?

  printf "%-80s" "Set i3 status config"
  sudo cp -r ./configs/i3status.conf /etc/i3status.conf &>/dev/null
  check $?

  printf "%-80s" "Set picom conf"
  sudo cp -r ./configs/picom.conf ~/.config/picom.conf &>/dev/null
  check $?

  printf "%-80s" "Set zshrc"
  sudo cp -r ./configs/zshrc ~/.zshrc &>/dev/null
  check $?

  printf "%-80s" "Set aliasrc"
  sudo cp -r ./configs/aliasrc ~/.config/aliasrc &>/dev/null
  check $?

}

create_folder () {

  echo " 
  ~ * Create directory tree Stage :
  "

  declare -a PASTAS=(
    cloud
    hashicorp
    helm3
    iac
    istio
    jenkins
    kubernetes
    monitoring
    nginx
    python3
    scripts
    sonarqube
  )

  for PASTA in ${PASTAS[@]}; do
    printf "%-80s" "Create $PASTA"
    mkdir -p ~/$PASTA &>/dev/null
    check $?
  done

}

clear

echo "
* ~ Dotfile Initializing
= = = = = = = = = = = = =
* ~ Wallace Bruno Gentil 

Some processes may take a few minutes please waiting...

"

setup

install_pac

install_yay

install_plugins

configuraterc
