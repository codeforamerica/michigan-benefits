#!/bin/bash
set -e

echo ">>> DISABLE STRICT HOST KEY CHECKING FOR SSH CONNECTIONS TO GITHUB"
touch /home/vagrant/.ssh/config
cat >> /home/vagrant/.ssh/config <<"EOF"
Host github.com
  StrictHostKeyChecking no
EOF

if [ ! -f /home/vagrant/.rbenv ]; then
  echo ">>> INSTALL RBENV"
  git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
  touch /home/vagrant/.bash_profile
  echo 'export PATH="/home/vagrant/.rbenv/bin:$PATH"' >> /home/vagrant/.bash_profile
  echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bash_profile
  git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
else
  echo ">>> RBENV ALREADY INSTALLED"
fi

echo ">>> INSTALL RUBY VIA RBENV"
source /home/vagrant/.bash_profile
cd /vagrant && rbenv install && rbenv rehash

echo ">>> GEMRC"
touch /home/vagrant/.gemrc
echo "gem: --no-document" >> /home/vagrant/.gemrc

echo ">>> INSTALL BUNDLER"
cd /vagrant && gem install bundler
rbenv rehash

echo ">>> BUNDLE"
cd /vagrant && bundle
