#!/bin/bash

bkp_dir="$HOME/.dotfiles_old"
target_dir="$HOME/.dotfiles"
# difine your bg here for solarized: dark or light
solarized_bg="dark"
dircolors=".dircolors"

files=(".vimrc" ".vim.after" ".bashrc" ".profile" ".zshrc" ".dircolors")

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

echo "\033[0;34nLinking .vim\033[0m"
ln -s $target_dir/.vim/janus/vim/vimrc $HOME/.vimrc

echo "\033[0;34nFix the 256 colors to solarized dark...\033[0m"
wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-$solarized_bg -P $target_dir/
mv $target_dir/dircolors.ansi-$solarized_bg $target_dir/$dircolors
eval `dircolors $HOME/$dircolors`

echo "\033[0;34nLooking for existing configs...\033[0m"
echo "\033[0;34nYour configurations will be backuped in $bkp_dir\033[0m"
mkdir $bkp_dir

for i in $files
do
  if [ -f $HOME/$i] || [ -h $HOME/$i]
  then
    echo "\033[0;34nBackuping $HOME/$i into $bkp_dir/$i...\033[0m"
    mv -r $HOME/$i $bkp_dir/$i
  fi
done

for i in $files
do
    echo "\033[0;34nLinking $i into your home...\033[0m"
    ln -s $target_dir/$i $HOME/$i
done

echo "\033[0;34nInstalling solarized dark theme...\033[0m"
.gnome-terminal-solarized/set_dark.sh


