#!/bin/bash

bkp_dir = "$HOME/.dotfiles_old"
target_dir = "$HOME/.dotfiles"

files=(".vimrc" ".vim.after" ".bashrc" ".profile" ".vim" ".zshrc")

echo "\033[0;34nCloning dotfiles...\033[0m"
hash git >/dev/null && /usr/bin/env git clone git@github.com:rbatista/dotfiles.git $target_dir || {
  echo "git not installed"
  exit
}

cd $target_dir

echo "\033[0;34nInitializing submodules...\033[0m"
/usr/bin/env git submodules init

echo "\033[0;34nand updating...\033[0m"
/usr/bin/env git submodules foreach git push origin master

echo "\033[0;34nLooking for existing configs...\033[0m"
echo "\033[0;34nYour configurations will be backuped in ~/.dotfiles_old/\033[0m"
mkdir $HOME/$bkp_dir

for i in $files
do
  if [ -f $HOME/$i] || [ -h $HOME/$i]
  then
    echo "\033[0;34nBackuping $HOME/$i into $bkp_dir/$i...\033[0m"
    mv -r $HOME/$i $bkp_dir/$i
    echo "\033[0;34nLinking $i into your home...\033[0m"
    ln -s $target_dir/$i $HOME/$i
  fi
done
