#!/bin/bash
# Script de RETO 1
# 21-11-2023

#Verificar usuario root
USERID=$(id -u)

if [ "${USERID}" -ne 0 ]; then
    echo -e "\Ejecutar con usuario ROOT"
    exit
fi 



# Update del sistema
echo "Actualizando sistema"
sudo apt update -y

echo "Instalando git"
apt install git -y

echo "Verificando aplicacion a utilizar"
paquete=("apache2" "mariadb-server" "php" "libapache2-mod-php" "php-mysql" "php-mbstring" "php-zip" "php-gd" "php-json" "php-curl")

for paquete in ${paquete[@]};
do
        if dpkg -l | grep -q $paquete;
        then
                echo "El paquete $paquete se encuentra instalado"

        else
                echo "Instalando paquete $paquete"
                sudo apt install -y "$paquete"

        fi
done


echo "Verificando inicio de servicios y habilitar"
#Iniciar Mariadb
if systemctl is-active --quiet mariadb;
then 
        echo "MariaDB esta activo"
else
        sudo systemctl start mariadb 
        echo "MariaDB esta activo"
fi

#Iniciar apache
if systemctl is-active --quiet apache2;
then 
        echo "Apache esta activo"
else
        sudo systemctl start apache2 
        echo "Apache esta activo"
fi

#habilitar inicio de Mariadb
if systemctl is-enabled --quiet mariadb;
then 
        echo "mariadb esta Habilitado para iniciar automaticamente"
else
        sudo systemctl enable amariadb 
        echo "mariadb esta Habilitado para iniciar automaticamente"
fi

#habilitar inicio de Apache

if systemctl is-enabled --quiet apache2;
then 
        echo "Apache esta Habilitado para iniciar automaticamente"
else
        sudo systemctl enable apache2 
        echo "Apache esta Habilitado para iniciar automaticamente"
fi


#Clonar repositorio

repo=bootcamp-devops-2023

if [ -d "$repo" ]; then
    echo -e "La carpeta $repo existe, se eliminara y volvera a descargar"
    rm -rf $repo
fi

git clone -b clase2-linux-bash https://github.com/roxsross/$repo.git


#Carga de web
sudo rm -fr /var/www/html/*
sudo cp -R bootcamp-devops-2023/app-295devops-travel/* /var/www/html/

sudo sed -i 's/""/"codepass"/g' /var/www/html/config.php
sudo sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php/g' /etc/apache2/mods-enabled/dir.conf

#Configurando base de datos
mysql -e "
CREATE DATABASE devopstravel;
CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
FLUSH PRIVILEGES;"


#llenado de base de datos para Ecommerce
mysql -u root < bootcamp-devops-2023/app-295devops-travel/database/devopstravel.sql

#Recargar apache2
sudo systemctl reload apache2
