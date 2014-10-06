#!/bin/bash
set -e

echo '>>> UPDATE APT'
apt-get update

echo '>>> INSTALL USEFUL TOOLS'
apt-get -y install git curl

echo '>>> INSTALL LIBS FOR COMPILATION'
apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev qt4-qmake libqtwebkit-dev libcurl4-openssl-dev libpq-dev

echo '>>> SET LOCALE (for Postgres)'
touch /etc/default/locale
cat > /etc/default/locale <<"EOF"
LANGUAGE="en_US.UTF-8"
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
EOF

echo '>>> INSTALL POSTGRES'
apt-get -y install postgresql-9.1

echo  '>>> ADD "vagrant" USER TO PSQL IF IT DOES NOT ALREADY EXIST'
sudo -u postgres psql postgres -tAc "select rolname from pg_roles where rolname='vagrant'" | grep -c vagrant || sudo -u postgres createuser --superuser vagrant

echo '>>> FIX POSTGRES LOCALE'
sudo -u postgres psql -c "update pg_database set datistemplate=false where datname='template1';"
sudo -u postgres psql -c "drop database Template1;"
sudo -u postgres psql -c "create database template1 with owner=postgres encoding='UTF-8' lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;"
sudo -u postgres psql -c "update pg_database set datistemplate=true where datname='template1';"
