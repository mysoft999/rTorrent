#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required: CentOS 7 X86_64                              #
#   Description: rTorrent + ruTorrent Soft Install                #
#   Author: LALA <QQ1062951199>                                   #
#   Website: https://www.lala.im                                  #
#=================================================================#

clear
echo
echo "#############################################################"
echo "# rTorrent + ruTorrent + FFMPEG Soft Install                #"
echo "# Author: LALA <QQ1062951199>                               #"
echo "# Website: https://www.lala.im                              #"
echo "# System Required: CentOS 7 X86_64                          #"
echo "#############################################################"
echo

# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
font="\033[0m"

# Install 0.9.8
install_0.9.8(){
# HostIP input
read -p "输入你的主机公网IP地址:" HostIP

# Disable SELinux
disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

# Stop SElinux
disable_selinux

# Disable Firewalld
systemctl stop firewalld.service
systemctl disable firewalld.service

# Update System
yum -y update
if [ $? -eq 0 ];then
    echo -e "${green} 系统更新完成 ${font}"
else 
    echo -e "${red} 系统更新失败 ${font}"
    exit 1
fi

# Install Required
cd ~
yum -y install wget
if [ $? -eq 0 ];then
    echo -e "${green} Wget安装成功 ${font}"
else 
    echo -e "${red} Wget安装失败 ${font}"
    exit 1
fi
yum -y install git
if [ $? -eq 0 ];then
    echo -e "${green} Git安装成功 ${font}"
else 
    echo -e "${red} Git安装失败 ${font}"
    exit 1
fi
yum -y install screen
if [ $? -eq 0 ];then
    echo -e "${green} Screen安装成功 ${font}"
else 
    echo -e "${red} Screen安装失败 ${font}"
    exit 1
fi
yum -y install epel-release
if [ $? -eq 0 ];then
    echo -e "${green} EPEL源安装成功 ${font}"
else 
    echo -e "${red} EPEL源安装失败 ${font}"
    exit 1
fi
yum -y install openssl-devel
if [ $? -eq 0 ];then
    echo -e "${green} Openssl-Devel安装成功 ${font}"
else 
    echo -e "${red} Openssl-Devel安装失败 ${font}"
    exit 1
fi
yum -y groupinstall "Development Tools"
if [ $? -eq 0 ];then
    echo -e "${green} 开发工具包安装成功 ${font}"
else 
    echo -e "${red} 开发工具包安装失败 ${font}"
    exit 1
fi
yum -y install ncurses-devel
if [ $? -eq 0 ];then
    echo -e "${green} Ncurses-Devel安装成功 ${font}"
else 
    echo -e "${red} Ncurses-Devel安装失败 ${font}"
    exit 1
fi
yum -y install xmlrpc-c-devel
if [ $? -eq 0 ];then
    echo -e "${green} Xmlrpc-C-Devel安装成功 ${font}"
else 
    echo -e "${red} Xmlrpc-C-Devel安装失败 ${font}"
    exit 1
fi
yum -y install mediainfo
if [ $? -eq 0 ];then
    echo -e "${green} Mediainfo安装成功 ${font}"
else 
    echo -e "${red} Mediainfo安装失败 ${font}"
    exit 1
fi

#Install Nginx
touch /etc/yum.repos.d/nginx.repo
cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/\$basearch/
gpgcheck=0
enabled=1
EOF
yum -y install nginx
if [ $? -eq 0 ];then
    echo -e "${green} Nginx安装成功 ${font}"
else 
    echo -e "${red} Nginx安装失败 ${font}"
    exit 1
fi

#Install PHP7.2
rpm -Uvh https://raw.githubusercontent.com/mysoft999/rTorrent/main/webtatic-release.rpm
yum -y install php72w-fpm php72w-cli php72w-common php72w-gd php72w-mysqlnd php72w-odbc php72w-pdo php72w-pgsql php72w-xmlrpc php72w-xml php72w-mbstring php72w-opcache
if [ $? -eq 0 ];then
    echo -e "${green} PHP7.2安装成功 ${font}"
else 
    echo -e "${red} PHP7.2安装失败 ${font}"
    exit 1
fi

# Install FFMPEG
cd ~
wget --no-check-certificate https://raw.githubusercontent.com/mysoft999/rTorrent/main/ffmpeg-release-amd64-static.tar.xz
tar -xJf ffmpeg-release-amd64-static.tar.xz
cd ffmpeg-6.0-amd64-static
cp ffmpeg /usr/bin/ffmpeg
cd ~
ffmpeg -version
if [ $? -eq 0 ];then
    echo -e "${green} FFMPEG安装成功 ${font}"
else 
    echo -e "${red} FFMPEG安装失败 ${font}"
    exit 1
fi

# Install unrar
cd ~
wget --no-check-certificate https://raw.githubusercontent.com/mysoft999/rTorrent/main/rarlinux-x64-621.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} Unrar下载成功 ${font}"
else 
    echo -e "${red} Unrar下载失败 ${font}"
    exit 1
fi
tar -xzvf rarlinux-x64-621.tar.gz
cd rar
make
if [ $? -eq 0 ];then
    echo -e "${green} Unrar安装成功 ${font}"
else 
    echo -e "${red} Unrar安装失败 ${font}"
    exit 1
fi

# Create Folder
mkdir /opt/rtorrent
mkdir /opt/rtorrent/download
mkdir /opt/rtorrent/.session
mkdir /opt/rtorrent/.watch

# Setting Environmental
echo "/usr/local/lib/" >> /etc/ld.so.conf
ldconfig
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# Install libtorrent
cd ~
wget https://github.com/rakshasa/rtorrent-archive/raw/master/libtorrent-0.13.8.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} libtorrent下载成功 ${font}"
else 
    echo -e "${red} libtorrent下载失败 ${font}"
    exit 1
fi
tar -xzvf libtorrent-0.13.8.tar.gz
cd libtorrent-0.13.8
./autogen.sh
./configure
make
make install
if [ $? -eq 0 ];then
    echo -e "${green}libtorrent安装成功 ${font}"
else 
    echo -e "${red}libtorrent安装失败 ${font}"
    exit 1
fi

# Install rTorrent
cd ~
wget https://raw.githubusercontent.com/mysoft999/rTorrent/main/rtorrent-0.9.8.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} rTorrent下载成功 ${font}"
else 
    echo -e "${red} rTorrent下载失败 ${font}"
    exit 1
fi
tar -xzvf rtorrent-0.9.8.tar.gz
cd rtorrent-0.9.8
./configure --with-xmlrpc-c
make
make install
if [ $? -eq 0 ];then
    echo -e "${green} rTorrent安装成功 ${font}"
else 
    echo -e "${red} rTorrent安装失败 ${font}"
    exit 1
fi

# Create rTorrent Config File
cd ~
touch .rtorrent.rc
cat > .rtorrent.rc <<EOF
# This is the rtorrent configuration file installed by LALA script - https://lala.im
# This file is installed to ~/.rtorrent.rc
# Enable/modify the options as needed, uncomment the options you wish to enable.
# This configuration will work well with most systems, but optimal settings are dependant on specific server setup


directory ="/opt/rtorrent/download/"
session ="/opt/rtorrent/.session"
schedule = watch_directory,5,5,load_start="/opt/rtorrent/.watch/*.torrent"

### BitTorrent
# Global upload and download rate in KiB, `0` for unlimited
throttle.global_down.max_rate.set = 0
throttle.global_up.max_rate.set = 0

# Maximum number of simultaneous downloads and uploads slots
throttle.max_downloads.global.set = 150
throttle.max_uploads.global.set = 150

# Maximum and minimum number of peers to connect to per torrent while downloading
throttle.min_peers.normal.set = 50
throttle.max_peers.normal.set = 51121

# Same as above but for seeding completed torrents (seeds per torrent)
throttle.min_peers.seed.set = 50
throttle.max_peers.seed.set = 51121

### Networking
network.port_range.set = 51001-51250
network.port_random.set = yes
dht.mode.set = auto
protocol.pex.set = no
trackers.use_udp.set = yes

# network.scgi.open_port = localhost:5000
network.scgi.open_port = 127.0.0.1:5000
network.http.ssl_verify_peer.set = 0
protocol.encryption.set = allow_incoming,enable_retry,prefer_plaintext

network.max_open_files.set = 65000
network.max_open_sockets.set = 4096
network.http.max_open.set = 4096
network.send_buffer.size.set = 256M
network.receive_buffer.size.set = 256M

### Memory Settings
pieces.hash.on_completion.set = no
pieces.preload.type.set = 1
pieces.memory.max.set = 2048M
EOF

# Download ruTorrent
cd /usr/share/nginx
wget --no-check-certificate https://raw.githubusercontent.com/mysoft999/rTorrent/main/ruTorrent-4.0.2.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} ruTorrent下载成功 ${font}"
else 
    echo -e "${red} ruTorrent下载失败 ${font}"
    exit 1
fi
tar -xzvf ruTorrent-4.0.2.tar.gz
mv ruTorrent-4.0.2 rutorrentt
chown -R apache:apache /usr/share/nginx/rutorrent

# Create ruToorent Password
touch /etc/nginx/htpasswd
echo "rTorrent:$apr1$yDfe2Wtr$y31KzoRixvQJe3Z5gatiL0" > /etc/nginx/htpasswd

# Create Nginx Rewrite Folder and ConfigFile
mkdir /etc/nginx/conf.d/rewrite
touch /etc/nginx/conf.d/rewrite/rutorrent.conf
cat > /etc/nginx/conf.d/rewrite/rutorrent.conf <<EOF
location /RPC2 {
  include scgi_params;
  scgi_pass 127.0.0.1:5000;
}
EOF

# Create Nginx MasterConfigFile
touch /etc/nginx/conf.d/rtorrent.conf
cat > /etc/nginx/conf.d/rtorrent.conf <<EOF
server {
    listen       12315;
    server_name  ${HostIP};

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        auth_basic "Your mother is biubiubiu";
        auth_basic_user_file htpasswd;
        root   /usr/share/nginx/rutorrent;
        index  index.html index.htm index.php;
        include /etc/nginx/conf.d/rewrite/rutorrent.conf;
    }

    location ~ \.php$ {
        auth_basic "Your mother is biubiubiu";
        auth_basic_user_file htpasswd;
        root           /usr/share/nginx/rutorrent;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /usr/share/nginx/rutorrent\$fastcgi_script_name;
        include        fastcgi_params;
    }

}
EOF

# Fix Bug is Curl Path
cat > /usr/share/nginx/rutorrent/conf/config.php <<EOF
<?php
	// configuration parameters

	// for snoopy client
	@define('HTTP_USER_AGENT', 'Mozilla/5.0 (Windows NT 6.0; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0', true);
	@define('HTTP_TIME_OUT', 30, true);	// in seconds
	@define('HTTP_USE_GZIP', true, true);
	\$httpIP = null;				// IP string. Or null for any.

	@define('RPC_TIME_OUT', 5, true);	// in seconds

	@define('LOG_RPC_CALLS', false, true);
	@define('LOG_RPC_FAULTS', true, true);

	// for php
	@define('PHP_USE_GZIP', false, true);
	@define('PHP_GZIP_LEVEL', 2, true);

	\$schedule_rand = 10;			// rand for schedulers start, +0..X seconds

	\$do_diagnostic = true;
	\$log_file = '/tmp/errors.log';		// path to log file (comment or leave blank to disable logging)

	\$saveUploadedTorrents = true;		// Save uploaded torrents to profile/torrents directory or not
	\$overwriteUploadedTorrents = false;     // Overwrite existing uploaded torrents in profile/torrents directory or make unique name

	\$topDirectory = '/';			// Upper available directory. Absolute path with trail slash.
	\$forbidUserSettings = false;

	\$scgi_port = 5000;
	\$scgi_host = "127.0.0.1";

	// For web->rtorrent link through unix domain socket 
	// (scgi_local in rtorrent conf file), change variables 
	// above to something like this:
	//
	// \$scgi_port = 0;
	// \$scgi_host = "unix:///tmp/rpc.socket";

	\$XMLRPCMountPoint = "/RPC2";		// DO NOT DELETE THIS LINE!!! DO NOT COMMENT THIS LINE!!!

	\$pathToExternals = array(
		"php" 	=> '',			// Something like /usr/bin/php. If empty, will be found in PATH.
		"curl"	=> '/usr/bin/curl',			// Something like /usr/bin/curl. If empty, will be found in PATH.
		"gzip"	=> '',			// Something like /usr/bin/gzip. If empty, will be found in PATH.
		"id"	=> '',			// Something like /usr/bin/id. If empty, will be found in PATH.
		"stat"	=> '',			// Something like /usr/bin/stat. If empty, will be found in PATH.
	);

	\$localhosts = array( 			// list of local interfaces
		"127.0.0.1",
		"localhost",
	);

	\$profilePath = '../share';		// Path to user profiles
	\$profileMask = 0777;			// Mask for files and directory creation in user profiles.
						// Both Webserver and rtorrent users must have read-write access to it.
						// For example, if Webserver and rtorrent users are in the same group then the value may be 0770.

	\$tempDirectory = null;			// Temp directory. Absolute path with trail slash. If null, then autodetect will be used.

	\$canUseXSendFile = false;		// If true then use X-Sendfile feature if it exist

	\$locale = "UTF8";
EOF

# Install 3rd ruTorrent Theme
cd /usr/share/nginx/rutorrent/plugins/theme/themes
git clone https://github.com/Phlooo/ruTorrent-MaterialDesign.git
chown -R apache:apache ruTorrent-MaterialDesign
git clone https://github.com/QuickBox/club-QuickBox.git
chown -R apache:apache club-QuickBox

# Fix PHP.ini Setting
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g" /etc/php.ini

# Start Nginx Service
systemctl restart nginx
systemctl enable nginx

# Start PHP Service
systemctl start php-fpm
systemctl enable php-fpm

# Boot Auto Running rTorrent
cd /etc/init.d
wget --no-check-certificate https://raw.githubusercontent.com/kevin-cn/rotorrent-install-for-centos7/master/rtorrent
chmod 755 rtorrent
chkconfig --add rtorrent
chkconfig rtorrent on

# Start rTorrent
/etc/init.d/rtorrent start

echo
echo "#############################################################"
echo "# rTorrent + ruTorrent Installation Complete                #"
echo "# ruTorrent WebSite: http://${HostIP}:12315                 #"
echo "# WebSite Account Name: rTorrent                            #"
echo "# WebSite Password: rTorrent.123                            #"
echo "# Change Password: /etc/nginx/htpasswd                      #"
echo "#############################################################"
echo
}

install_0.9.7(){
# HostIP input
read -p "输入你的主机公网IP地址:" HostIP

# Disable SELinux
disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

# Stop SElinux
disable_selinux

# Disable Firewalld
systemctl stop firewalld.service
systemctl disable firewalld.service

# Update System
yum -y update
if [ $? -eq 0 ];then
    echo -e "${green} 系统更新完成 ${font}"
else 
    echo -e "${red} 系统更新失败 ${font}"
    exit 1
fi

# Install Required
cd ~
yum -y install wget
if [ $? -eq 0 ];then
    echo -e "${green} Wget安装成功 ${font}"
else 
    echo -e "${red} Wget安装失败 ${font}"
    exit 1
fi
yum -y install git
if [ $? -eq 0 ];then
    echo -e "${green} Git安装成功 ${font}"
else 
    echo -e "${red} Git安装失败 ${font}"
    exit 1
fi
yum -y install screen
if [ $? -eq 0 ];then
    echo -e "${green} Screen安装成功 ${font}"
else 
    echo -e "${red} Screen安装失败 ${font}"
    exit 1
fi
yum -y install epel-release
if [ $? -eq 0 ];then
    echo -e "${green} EPEL源安装成功 ${font}"
else 
    echo -e "${red} EPEL源安装失败 ${font}"
    exit 1
fi
yum -y install openssl-devel
if [ $? -eq 0 ];then
    echo -e "${green} Openssl-Devel安装成功 ${font}"
else 
    echo -e "${red} Openssl-Devel安装失败 ${font}"
    exit 1
fi
yum -y groupinstall "Development Tools"
if [ $? -eq 0 ];then
    echo -e "${green} 开发工具包安装成功 ${font}"
else 
    echo -e "${red} 开发工具包安装失败 ${font}"
    exit 1
fi
yum -y install ncurses-devel
if [ $? -eq 0 ];then
    echo -e "${green} Ncurses-Devel安装成功 ${font}"
else 
    echo -e "${red} Ncurses-Devel安装失败 ${font}"
    exit 1
fi
yum -y install xmlrpc-c-devel
if [ $? -eq 0 ];then
    echo -e "${green} Xmlrpc-C-Devel安装成功 ${font}"
else 
    echo -e "${red} Xmlrpc-C-Devel安装失败 ${font}"
    exit 1
fi
yum -y install mediainfo
if [ $? -eq 0 ];then
    echo -e "${green} Mediainfo安装成功 ${font}"
else 
    echo -e "${red} Mediainfo安装失败 ${font}"
    exit 1
fi

#Install Nginx
touch /etc/yum.repos.d/nginx.repo
cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/\$basearch/
gpgcheck=0
enabled=1
EOF
yum -y install nginx
if [ $? -eq 0 ];then
    echo -e "${green} Nginx安装成功 ${font}"
else 
    echo -e "${red} Nginx安装失败 ${font}"
    exit 1
fi

#Install PHP7.2
rpm -Uvh https://raw.githubusercontent.com/mysoft999/rTorrent/main/webtatic-release.rpm
yum -y install php72w-fpm php72w-cli php72w-common php72w-gd php72w-mysqlnd php72w-odbc php72w-pdo php72w-pgsql php72w-xmlrpc php72w-xml php72w-mbstring php72w-opcache
if [ $? -eq 0 ];then
    echo -e "${green} PHP7.2安装成功 ${font}"
else 
    echo -e "${red} PHP7.2安装失败 ${font}"
    exit 1
fi

# Install FFMPEG
cd ~
wget --no-check-certificate https://raw.githubusercontent.com/mysoft999/rTorrent/main/ffmpeg-release-amd64-static.tar.xz
tar -xJf ffmpeg-release-amd64-static.tar.xz
cd ffmpeg-6.0-amd64-static
cp ffmpeg /usr/bin/ffmpeg
cd ~
ffmpeg -version
if [ $? -eq 0 ];then
    echo -e "${green} FFMPEG安装成功 ${font}"
else 
    echo -e "${red} FFMPEG安装失败 ${font}"
    exit 1
fi

# Install unrar
cd ~
wget --no-check-certificate https://raw.githubusercontent.com/mysoft999/rTorrent/main/rarlinux-x64-621.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} Unrar下载成功 ${font}"
else 
    echo -e "${red} Unrar下载失败 ${font}"
    exit 1
fi
tar -xzvf rarlinux-x64-621.tar.gz
cd rar
make
if [ $? -eq 0 ];then
    echo -e "${green} Unrar安装成功 ${font}"
else 
    echo -e "${red} Unrar安装失败 ${font}"
    exit 1
fi

# Create Folder
mkdir /opt/rtorrent
mkdir /opt/rtorrent/download
mkdir /opt/rtorrent/.session
mkdir /opt/rtorrent/.watch

# Setting Environmental
echo "/usr/local/lib/" >> /etc/ld.so.conf
ldconfig
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# Install libtorrent
cd ~
wget https://github.com/rakshasa/rtorrent-archive/raw/master/libtorrent-0.13.8.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} libtorrent下载成功 ${font}"
else 
    echo -e "${red} libtorrent下载失败 ${font}"
    exit 1
fi
tar -xzvf libtorrent-0.13.8.tar.gz
cd libtorrent-0.13.8
./autogen.sh
./configure
make
make install
if [ $? -eq 0 ];then
    echo -e "${green}libtorrent安装成功 ${font}"
else 
    echo -e "${red}libtorrent安装失败 ${font}"
    exit 1
fi

# Install rTorrent
cd ~
wget https://raw.githubusercontent.com/mysoft999/rTorrent/main/rtorrent-0.9.7.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} rTorrent下载成功 ${font}"
else 
    echo -e "${red} rTorrent下载失败 ${font}"
    exit 1
fi
tar -xzvf rtorrent-0.9.7.tar.gz
cd rtorrent-0.9.7
./configure --with-xmlrpc-c
make
make install
if [ $? -eq 0 ];then
    echo -e "${green} rTorrent安装成功 ${font}"
else 
    echo -e "${red} rTorrent安装失败 ${font}"
    exit 1
fi

# Create rTorrent Config File
cd ~
touch .rtorrent.rc
cat > .rtorrent.rc <<EOF
# This is the rtorrent configuration file installed by LALA script - https://lala.im
# This file is installed to ~/.rtorrent.rc
# Enable/modify the options as needed, uncomment the options you wish to enable.
# This configuration will work well with most systems, but optimal settings are dependant on specific server setup


directory ="/opt/rtorrent/download/"
session ="/opt/rtorrent/.session"
schedule = watch_directory,5,5,load_start="/opt/rtorrent/.watch/*.torrent"

### BitTorrent
# Global upload and download rate in KiB, `0` for unlimited
throttle.global_down.max_rate.set = 0
throttle.global_up.max_rate.set = 0

# Maximum number of simultaneous downloads and uploads slots
throttle.max_downloads.global.set = 150
throttle.max_uploads.global.set = 150

# Maximum and minimum number of peers to connect to per torrent while downloading
throttle.min_peers.normal.set = 50
throttle.max_peers.normal.set = 51121

# Same as above but for seeding completed torrents (seeds per torrent)
throttle.min_peers.seed.set = 50
throttle.max_peers.seed.set = 51121

### Networking
network.port_range.set = 51001-51250
network.port_random.set = yes
dht.mode.set = auto
protocol.pex.set = no
trackers.use_udp.set = yes

# network.scgi.open_port = localhost:5000
network.scgi.open_port = 127.0.0.1:5000
network.http.ssl_verify_peer.set = 0
protocol.encryption.set = allow_incoming,enable_retry,prefer_plaintext

network.max_open_files.set = 65000
network.max_open_sockets.set = 4096
network.http.max_open.set = 4096
network.send_buffer.size.set = 256M
network.receive_buffer.size.set = 256M

### Memory Settings
pieces.hash.on_completion.set = no
pieces.preload.type.set = 1
pieces.memory.max.set = 2048M
EOF

# Download ruTorrent
cd /usr/share/nginx
wget --no-check-certificate https://raw.githubusercontent.com/mysoft999/rTorrent/main/ruTorrent-4.0.2.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} ruTorrent下载成功 ${font}"
else 
    echo -e "${red} ruTorrent下载失败 ${font}"
    exit 1
fi
tar -xzvf ruTorrent-4.0.2.tar.gz
mv ruTorrent-4.0.2 rutorrentt
chown -R apache:apache /usr/share/nginx/rutorrent

# Create ruToorent Password
touch /etc/nginx/htpasswd
echo "rTorrent:$apr1$yDfe2Wtr$y31KzoRixvQJe3Z5gatiL0" > /etc/nginx/htpasswd

# Create Nginx Rewrite Folder and ConfigFile
mkdir /etc/nginx/conf.d/rewrite
touch /etc/nginx/conf.d/rewrite/rutorrent.conf
cat > /etc/nginx/conf.d/rewrite/rutorrent.conf <<EOF
location /RPC2 {
  include scgi_params;
  scgi_pass 127.0.0.1:5000;
}
EOF

# Create Nginx MasterConfigFile
touch /etc/nginx/conf.d/rtorrent.conf
cat > /etc/nginx/conf.d/rtorrent.conf <<EOF
server {
    listen       12315;
    server_name  ${HostIP};

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        auth_basic "Your mother is biubiubiu";
        auth_basic_user_file htpasswd;
        root   /usr/share/nginx/rutorrent;
        index  index.html index.htm index.php;
        include /etc/nginx/conf.d/rewrite/rutorrent.conf;
    }

    location ~ \.php$ {
        auth_basic "Your mother is biubiubiu";
        auth_basic_user_file htpasswd;
        root           /usr/share/nginx/rutorrent;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /usr/share/nginx/rutorrent\$fastcgi_script_name;
        include        fastcgi_params;
    }

}
EOF

# Fix Bug is Curl Path
cat > /usr/share/nginx/rutorrent/conf/config.php <<EOF
<?php
	// configuration parameters

	// for snoopy client
	@define('HTTP_USER_AGENT', 'Mozilla/5.0 (Windows NT 6.0; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0', true);
	@define('HTTP_TIME_OUT', 30, true);	// in seconds
	@define('HTTP_USE_GZIP', true, true);
	\$httpIP = null;				// IP string. Or null for any.

	@define('RPC_TIME_OUT', 5, true);	// in seconds

	@define('LOG_RPC_CALLS', false, true);
	@define('LOG_RPC_FAULTS', true, true);

	// for php
	@define('PHP_USE_GZIP', false, true);
	@define('PHP_GZIP_LEVEL', 2, true);

	\$schedule_rand = 10;			// rand for schedulers start, +0..X seconds

	\$do_diagnostic = true;
	\$log_file = '/tmp/errors.log';		// path to log file (comment or leave blank to disable logging)

	\$saveUploadedTorrents = true;		// Save uploaded torrents to profile/torrents directory or not
	\$overwriteUploadedTorrents = false;     // Overwrite existing uploaded torrents in profile/torrents directory or make unique name

	\$topDirectory = '/';			// Upper available directory. Absolute path with trail slash.
	\$forbidUserSettings = false;

	\$scgi_port = 5000;
	\$scgi_host = "127.0.0.1";

	// For web->rtorrent link through unix domain socket 
	// (scgi_local in rtorrent conf file), change variables 
	// above to something like this:
	//
	// \$scgi_port = 0;
	// \$scgi_host = "unix:///tmp/rpc.socket";

	\$XMLRPCMountPoint = "/RPC2";		// DO NOT DELETE THIS LINE!!! DO NOT COMMENT THIS LINE!!!

	\$pathToExternals = array(
		"php" 	=> '',			// Something like /usr/bin/php. If empty, will be found in PATH.
		"curl"	=> '/usr/bin/curl',			// Something like /usr/bin/curl. If empty, will be found in PATH.
		"gzip"	=> '',			// Something like /usr/bin/gzip. If empty, will be found in PATH.
		"id"	=> '',			// Something like /usr/bin/id. If empty, will be found in PATH.
		"stat"	=> '',			// Something like /usr/bin/stat. If empty, will be found in PATH.
	);

	\$localhosts = array( 			// list of local interfaces
		"127.0.0.1",
		"localhost",
	);

	\$profilePath = '../share';		// Path to user profiles
	\$profileMask = 0777;			// Mask for files and directory creation in user profiles.
						// Both Webserver and rtorrent users must have read-write access to it.
						// For example, if Webserver and rtorrent users are in the same group then the value may be 0770.

	\$tempDirectory = null;			// Temp directory. Absolute path with trail slash. If null, then autodetect will be used.

	\$canUseXSendFile = false;		// If true then use X-Sendfile feature if it exist

	\$locale = "UTF8";
EOF

# Install 3rd ruTorrent Theme
cd /usr/share/nginx/rutorrent/plugins/theme/themes
git clone https://github.com/Phlooo/ruTorrent-MaterialDesign.git
chown -R apache:apache ruTorrent-MaterialDesign
git clone https://github.com/QuickBox/club-QuickBox.git
chown -R apache:apache club-QuickBox

# Fix PHP.ini Setting
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g" /etc/php.ini

# Start Nginx Service
systemctl restart nginx
systemctl enable nginx

# Start PHP Service
systemctl start php-fpm
systemctl enable php-fpm

# Boot Auto Running rTorrent
cd /etc/init.d
wget --no-check-certificate https://raw.githubusercontent.com/kevin-cn/rotorrent-install-for-centos7/master/rtorrent
chmod 755 rtorrent
chkconfig --add rtorrent
chkconfig rtorrent on

# Start rTorrent
/etc/init.d/rtorrent start

echo
echo "#############################################################"
echo "# rTorrent + ruTorrent Installation Complete                #"
echo "# ruTorrent WebSite: http://${HostIP}:12315                 #"
echo "# WebSite Account Name: rTorrent                            #"
echo "# WebSite Password: rTorrent.123                            #"
echo "# Change Password: /etc/nginx/htpasswd                      #"
echo "#############################################################"
echo
}

# 开始菜单设置
start_menu(){
	read -p "请输入数字(1或2)，1安装rTorrent0.9.8，2安装rTorrent0.9.7:" num
	case "$num" in
		1)
		install_0.9.8
		;;
		2)
		install_0.9.7
		;;
	esac
}

# 运行开始菜单
start_menu
