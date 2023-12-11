#!/bin/bash
# Script de RETO 1
# 21-11-2023


mysql -e "
CREATE DATABASE devopstravel;
CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
FLUSH PRIVILEGES;"



#llenado de base de datos para Ecommerce
msql -u root < /bootcamp-devops-2023/app-295devops-travel/database/devopstravel.sql


#Recargar apache2
sudo systemctl reload apache2