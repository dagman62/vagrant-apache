# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  #config.vm.network "private_network", ip: "192.168.0.254"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  config.vm.network "public_network", bridge: "wlo1",
  use_dhcp_assigned_default_route: true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
  APR_VER="1.6.3"
  APRU_VER="1.6.1"
  HTTP_VER="2.4.33"
  PHP_VER="7.2.5"
  HTTP_PREFIX="/usr/local/apache"
  TMP_DIR="/tmp"
  apt-get update && apt-get install -y \
  wget \
  libexpat1-dev \
  libpcre++-dev \
  libxml2-dev \
  zlib1g-dev \
  gcc \
  make
  cd ${TMP_DIR}
  wget http://www-us.apache.org/dist//apr/apr-${APR_VER}.tar.gz
  tar -zxvf apr-${APR_VER}.tar.gz
  rm -f apr-${APR_VER}.tar.gz
  cd ${TMP_DIR}/apr-${APR_VER}
  ./configure --prefix=${HTTP_PREFIX} \
  && make && make install
  cd ${TMP_DIR}
  wget http://www-us.apache.org/dist//apr/apr-util-${APRU_VER}.tar.gz
  tar -zxvf apr-util-${APRU_VER}.tar.gz
  rm -f apr-util-${APRU_VER}.tar.gz
  cd ${TMP_DIR}/apr-util-${APRU_VER}
  ./configure --prefix=${HTTP_PREFIX} --with-apr=${HTTP_PREFIX}/bin/apr-1-config \
  && make && make install
  cd ${TMP_DIR}
  wget --no-check-certificate https://archive.apache.org/dist/httpd/httpd-${HTTP_VER}.tar.gz
  tar -zxvf httpd-${HTTP_VER}.tar.gz
  rm -f httpd-${HTTP_VER}.tar.gz
  cd ${TMP_DIR}/httpd-${HTTP_VER}
  ./configure \
  --prefix=${HTTP_PREFIX} \
  --with-mpm=prefork \
  --with-apr=${HTTP_PREFIX}/bin/apr-1-config \
  --with-apr-util=${HTTP_PREFIX}/bin/apu-1-config \
  && make &&  make install
  cd ${TMP_DIR}
  wget http://us1.php.net/distributions/php-${PHP_VER}.tar.gz
  tar -zxvf php-${PHP_VER}.tar.gz
  rm -f php-${PHP_VER}.tar.gz
  cd ${TMP_DIR}/php-${PHP_VER}
 ./configure \
 --with-zlib \
 --enable-static \
 --with-apxs2=${HTTP_PREFIX}/bin/apxs \
 --with-mysqli \
 --enable-embedded-mysqli \
 --enable-dba \
  && make && make install
  cp /vagrant/data/httpd.conf /usr/local/apache/conf
  cp /vagrant/data/start-apache /usr/local/bin
  rm -rf /tmp/*
  apt-get purge -y --auto-remove \
  wget \
  gcc \
  make \
  && rm -rf /var/lib/apt/lists/*
  chmod +x /usr/local/bin/start-apache
  start-apache 
  SHELL
end
