#!/bin/bash
# Script de RETO 1
# 21-11-2023


# Declaracion de variables


# Update del sistema
Echo "Actualizando sistema"
sudo apt update -y


Echo "Verificando aplicacion a utilizar"

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

#Configurando base de datos
mysql -e "
 CREATE DATABASE ecomdb;
 CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
 GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
 FLUSH PRIVILEGES;"


#llenado de base de datos para Ecommerce
 cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

mysql < db-load-script.sql


#parte web

sudo apt install git -y
git clone https://github.com/roxsross/The-DevOps-Journey-101.git
sudo cp -r The-DevOps-Journey-101/CLASE-02/lamp-app-ecommerce/* /var/www/html/

#Descarga de web
sudo mv /var/www/html/index.html /var/www/html/index.html.bkp


sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php
sudo systemctl reload apache2
