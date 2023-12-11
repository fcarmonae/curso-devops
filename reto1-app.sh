#!/bin/bash
# Script de RETO 1
# 21-11-2023


# Declaracion de variables


# Update del sistema
echo "Actualizando sistema"
sudo apt update -y


echo "Verificando aplicacion a utilizar"

paquete=("git" "apache2" "mariadb-server" "php" "libapache2-mod-php" "php-mysql" )

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
