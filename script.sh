#!/bin/bash
# Script_Instalação do AtoM -  Ubuntu 14.04
# Claiton Denardi Paulus
# BaseGED_2018/1

echo "Script de instalação AtoM, sua senha de root poderá ser solicitada em certos momentos."

if which -a mysql
   then
   echo "MYSQL INSTALADO"
   read -t 1
else
   read -t 2
   sudo apt-get install -y mysql-server-5.5
fi

if which -a mysql
   then
   if which -a java
      then
      echo "JAVA JÁ INSTALADO"
      read -t 1
   else
      read -t 2
      sudo apt-get install -y openjdk-7-jre-headless
   fi
else
   echo "ERRO NA INSTALAÇÃO"
fi

if which -a mysql java
   then
   if [ -e elasticsearch-1.7.2.deb ]
   	then
   	sudo dpkg -i elasticsearch-1.7.2.deb
   	sudo update-rc.d elasticsearch defaults
   	sudo /etc/init.d/elasticsearch start
   else
   	read -t 2
   	wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.2.deb
   	sudo dpkg -i elasticsearch-1.7.2.deb
   	sudo update-rc.d elasticsearch defaults
   	sudo /etc/init.d/elasticsearch start
   fi
else
   echo "ERRO"
fi

if which -a mysql java #"$elastisearch"
   then
   sudo apt-get install -y nginx
   sudo touch /etc/nginx/sites-available/atom
   sudo ln -sf /etc/nginx/sites-available/atom /etc/nginx/sites-enabled/atom
   sudo rm /etc/nginx/sites-enabled/default
   sudo mv atom /etc/nginx/sites-enabled/
   sudo service nginx restart
else
   echo "PROBLEMA COM DEPENDENCIAS"
fi

if which -a mysql java nginx #"$elastisearch"
   then
   if which -a php
      then
      echo "PHP JÁ INSTALADO"
   else
      sudo apt-get install -y php5-cli php5-fpm php5-curl php5-mysql php5-xsl php5-json php5-ldap php-apc
      sudo apt-get install -y php5-readline
      sudo mv atom.conf /etc/php5/fpm/pool.d/
      sudo service php5-fpm restart
      sudo php5-fpm --test
   fi
else
   echo "ERRO"
fi

echo "PACOTES ADICIONAIS ATOM"
sudo apt-get install -y gearman-job-server
wget https://archive.apache.org/dist/xmlgraphics/fop/binaries/fop-1.0-bin.tar.gz
tar -zxvf fop-1.0-bin.tar.gz
rm fop-1.0-bin.tar.gz
mv fop-1.0 /usr/share
ln -s /usr/share/fop-1.0/fop /usr/bin/fop
sudo echo 'FOP_HOME="/usr/share/fop-1.0"' >> /etc/environment
sudo apt-get install -y imagemagick ghostscript poppler-utils
sudo add-apt-repository ppa:archivematica/externals
sudo apt-get update
sudo apt-get install -y ffmpeg


wget https://storage.accesstomemory.org/releases/atom-2.2.1.tar.gz
sudo mkdir /usr/share/nginx/atom
sudo tar xzf atom-2.2.1.tar.gz -C /usr/share/nginx/atom --strip 1
sudo chown -R www-data:www-data /usr/share/nginx/atom
sudo chmod o= /usr/share/nginx/atom


echo "Insira sua senha quando Solicitado"
mysql -h localhost -u root -p -e "CREATE DATABASE atom CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -h localhost -u root -p -e "GRANT INDEX, CREATE, SELECT, INSERT, UPDATE, DELETE, ALTER, LOCK TABLES ON atom.* TO 'atom'@'localhost' IDENTIFIED BY '12345';"

echo "http://localhost NO SEU NAVEGADOR FAVORITO E CONCLUA A INSTALAÇÃO DO ATOM ATRAVÉS DO WEB INSTALLER"
