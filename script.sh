#!/bin/bash

cd $HOME

sudo umount -L arquivos
sudo mkdir /mnt/arquivos
sudo mount -L arquivos /mnt/arquivos

mkdir $HOME/.Templates
echo "
XDG_DESKTOP_DIR=\"$HOME/Desktop\"
XDG_DOWNLOAD_DIR=\"$HOME/Downloads\"
XDG_TEMPLATES_DIR=\"$HOME/.Templates\"
XDG_PUBLICSHARE_DIR=\"$HOME/Público\"
XDG_DOCUMENTS_DIR=\"$HOME/Documentos\"
XDG_MUSIC_DIR=\"$HOME/\"
XDG_PICTURES_DIR=\"$HOME/Imagens\"
XDG_VIDEOS_DIR=\"$HOME/Vídeos\"
" > $HOME/.config/user-dirs.dirs


#Cria link das pastas de usuário para o HD
rm -rf ~/Downloads/ ~/Modelos/ ~/Imagens/ ~/Público/ ~/Vídeos/ ~/Documentos/ ~/Música/
rm -rf Modelos/

mkdir Arquivos/Documentos/ Arquivos/Downloads/ Arquivos/Imagens Arquivos/Músicas/ Arquivos/Público/ Arquivos/Desenvolvimento/ Arquivos/cursos Arquivos/Vídeos/ Arquivos/Desktop

ln -sf /mnt/arquivos/ Arquivos
ln -sf Arquivos/Documentos/
ln -sf Arquivos/Downloads/
ln -sf Arquivos/Imagens/ Imagens
ln -sf Arquivos/Músicas/
ln -sf Arquivos/Público/
ln -sf Arquivos/Desenvolvimento/ 
ln -sf Arquivos/cursos Cursos
ln -sf Arquivos/Vídeos/
ln -sf Arquivos/Desktop
ln -sf Arquivos/utilidades/binarios_linux .bin
#Montagem do hdd na fstab
echo "UUID=$UUID /mnt/arquivos ext4 defaults 0  2" | sudo tee -a /etc/fstab

#instalações que exigem interação
sudo apt install -y samba lightdm; \
sudo smbpasswd -a $(whoami)


#instalanção de pacotes
sudo apt install -y \
wget \
curl \
git \
vim vim-gtk3 \
mosquitto \
xclip \
linux-tools-$(uname -r) \
sqlite3 \
sqlitebrowser \
net-tools \
apt-transport-https \
ca-certificates \
software-properties-common \
vlc \
libaio1 mousepad openvpn network-manager-openvpn \
sqlite3 sqlitebrowser \
gimp kdenlive gnome-tweak-tool \
libcanberra-gtk-module cmake \
dconf-cli gnome-tweak-tool \
gnome-shell-extensions network-manager-openvpn \
network-manager-openvpn-gnome \
python3-pip exuberant-ctags ack-grep neovim i3lock libpq-dev \
onedrive;

sudo snap install --classic heroku
sudo pip3 install pynvim flake8 pylint isort jedi


#Pacotes que exigem repositório
#Driver nvidia
sudo apt-add-repository ppa:graphics-drivers/ppa -y && \
sudo apt update -y && sudo apt upgrade
#Spotify
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list && \
sudo apt update -y && sudo apt upgrade -y && \
sudo apt install -y spotify-client

#Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y && \
sudo apt update -y && sudo apt upgrade -y && \
sudo apt install -y docker-ce docker-ce-cli containerd.io && \
sudo usermod -aG docker $(whoami)
#Docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
sudo chmod +x /usr/local/bin/docker-compose


cp ./aliases ~/.bash_aliases
source ~/.bash_aliases

# Esquema de cores do terminal
# bash -c  "$(wget -qO- https://git.io/vQgMr)" 

#Personalizar o VIM
git clone https://github.com/im-alexandre/vimrc.git && \
cd vimrc/ && \
mv vimrc/init.d ~/.config/nvim/ && /
mv .config/nvim/.vimrc .config/nvim/init.vim

# Incluir o ramo do git no ps1
source /usr/lib/git-core/git-sh-prompt
#incluir $(__git_ps1 "(%s)")\n antes do \$ do ps1
=================================================================================================================================================

#Instalação dos pacotes locais
#Copia para o diretório /opt
sudo cp $(find /mnt/arquivos/utilidades/instala_so/programas/ -iname sqldeveloper*.zip) /opt && \
sudo cp $(find /mnt/arquivos/utilidades/instala_so/programas/ -iname jdk*.tar.gz) /opt && \
sudo cp $(find /mnt/arquivos/utilidades/instala_so/programas/ -iname arduino-*-linux64.tar.xz) /opt && \
sudo cp /mnt/arquivos/utilidades/instala_so/programas/weka-3-8-4-azul-zulu-linux.zip /opt

#Descompacta
cd /opt && \
sudo tar -xf $(find . -iname jdk*.tar.gz) && \
sudo tar -xf $(find . -iname arduino-*-linux64.tar.xz) && \
sudo unzip $(find . -iname sqldeveloper*.zip) && \
sudo unzip $(find . -iname weka*.zip)

#arduino
sudo /opt/arduino/install.sh && \
sudo usermod -aG tty $(whoami); \
sudo usermod -aG dialout $(whoami)

#brmodel
sudo mkdir /opt/brmodelo; \
sudo cp /mnt/arquivos/utilidades/instala_so/programas/brModelo.jar /opt/brmodelo/

# copia os "executáveis" para o /usr/local/bin
sudo cp /mnt/arquivos/utilidades/instala_so/programas/weka_bin.sh /usr/local/bin/weka; \
sudo cp /mnt/arquivos/utilidades/instala_so/programas/brmodelo_bin.sh /usr/local/bin/brmodelo; \
sudo cp /mnt/arquivos/utilidades/instala_so/programas/sqldeveloper /usr/local/bin/sqldeveloper

# permissão de execução para os "executáveis"
sudo chmod a+x /usr/local/bin/*; \
mkdir -p /home/alexandre/.local/share/icons &&
cp /home/alexandre/Arquivos/utilidades/instala_so/programas/icons/* ~/.local/share/icons/; \
sudo chmod a+x ~/Arquivos/Desktop/*.desktop; \
sudo cp /home/alexandre/Arquivos/utilidades/instala_so/programas/desktop/*.desktop /usr/share/applications/

#Configurações do java e sqldeveloper
cat /mnt/arquivos/utilidades/instala_so/programas/env_var_java >> ~/.bashrc; \
echo "SetJavqld	Home /opt/java" >> $(find ~/.sqldeveloper -iname product.conf)

#Bibliotecas Steam
sudo /home/$(whoami)/Arquivos/utilidades/instala_so/programas/steam_libs;

#Compartilhamento SAMBA
echo "
[notebook]
   path = /home/alexandre/Público
   browseable = yes
   read only = no
   guest ok = no
" | sudo tee -a /etc/samba/smb.conf;

sudo /etc/init.d/smbd restart
sudo /etc/init.d/samba-ad-dc restart

~/Arquivos/utilidades/instala_so/programas/tearing_fix.sh

# instalar os pacotes baixados
sudo apt install -y ./zoom_amd64.deb \
./epson-inkjet-printer-escpr_1.6.40-1lsb3.2_amd64.deb \
./code_1.43.2-1585036376_amd64.deb \
./google-chrome-stable_current_amd64.deb; \
./Anaconda3-2020.02-Linux-x86_64.sh -b -f -p ~/.anaconda3; \
~/.anaconda3/bin/conda init; \
source ~/.bashrc; \
conda update --all -y; \

# Inclui o instant client no PATH
echo "export LD_LIBRARY_PATH=/opt/instantclient_12_2:$LD_LIBRARY_PATH" >> ~/.bashrc; \
sudo cp instantclient-basic-linux.x64-12.2.0.1.0.zip /opt; \
cd /opt; \
sudo unzip instantclient-basic-linux.x64-12.2.0.1.0.zip; \
cd /opt/instantclient_12_2; \
sudo ln -sf libclntsh.so.12.1 libclntsh.so; \
sudo cp libclntsh.so libclntsh.so.1; \
sudo apt update -y && sudo apt upgrade -y

pip install install pynvim flake8 pylint isort jedi
