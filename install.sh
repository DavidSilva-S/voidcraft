#!/bin/bash

# Sair imediatamente se algum comando falhar
set -e

echo "=========================================================="
# 1. INSTALAÇÃO DE TODAS AS DEPENDÊNCIAS DO VOID
# ==========================================================
echo "=== 1/4: Instalando dependências via XBPS ==="

DEPENDENCIAS=(
    "base-devel" "gd-devel" "pkg-config"
    "libX11-devel" "libXinerama-devel" "libXft-devel" "freetype-devel"
    "hsetroot" "xsettingsd" "pulsemixer" "light" "rofi" "dunst"
    "alacritty" "thunar" "geany" "firefox" "viewnior"
    "betterlockscreen" "ksuperkey" "mpd" "mpc" "ffmpeg"
    "maim" "xclip" "xcolor" "xfce4-power-manager"
    "xorg-xsetroot" "yad" "wmname"
)

sudo xbps-install -Sy "${DEPENDENCIAS[@]}"


echo "=========================================================="
# 2. DOWNLOAD DO REPOSITÓRIO COM RECURSIVE
# ==========================================================
echo "=== 2/4: Baixando DWM e ST juntos via --recursive ==="
rm -rf /tmp/archcraft-dwm-repo

# Clona o repositório principal e já traz o submódulo do st junto
git clone --recursive https://github.com/archcraft-os/archcraft-dwm.git /tmp/archcraft-dwm-repo


echo "=========================================================="
# 3. COMPILAR E INSTALAR O ARCHCRAFT DWM PRIMEIRO
# ==========================================================
echo "=== 3/4: Compilando e Instalando o Archcraft DWM ==="
cd /tmp/archcraft-dwm-repo/archcraft-dwm/source

# Compilação do DWM
make X11INC=/usr/include/X11 X11LIB=/usr/lib FREETYPEINC=/usr/include/freetype2
sudo make PREFIX=/usr install

# Arquivo de sessão para a tela de login
sudo install -Dm644 dwm.desktop /usr/share/xsessions/dwm.desktop

# Copia os arquivos de Rice (Barras, temas e scripts do rofi)
sudo mkdir -p /usr/share/archcraft
sudo cp -rf /tmp/archcraft-dwm-repo/archcraft-dwm/shared /usr/share/archcraft/dwm
sudo chmod +x /usr/share/archcraft/dwm/scripts/*


echo "=========================================================="
# 4. COMPILAR E INSTALAR O ARCHCRAFT ST POR ÚLTIMO
# ==========================================================
echo "=== 4/4: Compilando e Instalando o Archcraft ST ==="
# Entra na pasta do st que veio junto pelo submódulo
cd /tmp/archcraft-dwm-repo/archcraft-st/archcraft-st/source

# Compilação do Terminal
make X11INC=/usr/include/X11 X11LIB=/usr/lib FREETYPEINC=/usr/include/freetype2
sudo make PREFIX=/usr install


echo "=========================================================="
echo "===               ¡PROCESSO CONCLUÍDO!                 ==="
echo "=========================================================="
echo "Ordem de instalação concluída com sucesso."
echo "1. Clonagem recursiva feita."
echo "2. DWM e Rice instalados."
echo "3. Terminal ST instalado."
echo ""
echo "Agora é só fechar sua sessão atual e entrar pelo DWM!"
