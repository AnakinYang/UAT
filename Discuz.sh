#! /bin/sh
yum install -y httpd php php-fpm mysql mysql-server php-mysql
yum reinstall -y httpd php php-fpm mysql mysql-server php-mysql
systemctl start httpd&&systemctl enable httpd
systemctl start php-fpm&&systemctl enable php-fpm
wget http://download.comsenz.com/DiscuzX/3.3/Discuz_X3.3_SC_UTF8.zip
unzip Discuz_X3.3_SC_UTF8.zip
mv /root/upload/* /var/www/html
chmod -R 777 /var/www/html
