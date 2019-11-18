#!/bin/bash

APACHE_ZIP="https://www.apachelounge.com/download/VS16/binaries/httpd-2.4.41-win64-VS16.zip"
PHP_ZIP="https://windows.php.net/downloads/releases/php-7.3.11-Win32-VC15-x64.zip"

# an up-to-date upx is preferable now that development has started again
if [ ! -e "./upx" ]; then
    echo "Please place an up-to-date upx binary in this directory"
    echo "See https://github.com/upx/upx/releases/"
    exit
fi

# we use previously downloaded files, but we warn about it
if [ -d "tmp" ]; then
    echo "WARNING: tmp exist, previous downloads will be used. Abort and delete tmp for fresh sources."
    read
fi

# clean up
if [ -d "out" ]; then
    rm -rf out
fi

# create folders
mkdir -p tmp
mkdir -p out
mkdir -p out/server
mkdir -p out/server/modules
mkdir -p out/server/php
mkdir -p out/server/php/ext

# copy default configs
cp -r tpl/* out/

# download and unpack Apache and PHP
if [ ! -f "tmp/apache.zip" ]; then
    wget --user-agent="" "$APACHE_ZIP" -O tmp/apache.zip
fi
if [ ! -f "tmp/php.zip" ]; then
    wget "$PHP_ZIP" -O tmp/php.zip
fi
if [ -d "tmp/apache" ]; then
    rm -rf tmp/apache
fi
if [ -d "tmp/php" ]; then
    rm -rf tmp/php
fi
cd tmp
    unzip apache.zip
    mv Apache[0-9][0-9] apache
    rm -f ReadMe.txt
    rm -f -- --*

    mkdir php
    cd php
    unzip ../php.zip
    cd ..
cd ..

# copy stuff
cp tmp/apache/LICENSE.txt                   out/server/apache-license.txt
cp tmp/apache/bin/httpd.exe                 out/server/mapache.exe
cp tmp/apache/bin/libapr-1.dll              out/server/
cp tmp/apache/bin/libapriconv-1.dll         out/server/
cp tmp/apache/bin/libaprutil-1.dll          out/server/
cp tmp/apache/bin/libhttpd.dll              out/server/
cp tmp/apache/bin/pcre.dll                  out/server/
cp tmp/apache/modules/mod_access_compat.so  out/server/modules/
cp tmp/apache/modules/mod_authz_core.so     out/server/modules/
cp tmp/apache/modules/mod_dir.so            out/server/modules/
cp tmp/apache/modules/mod_env.so            out/server/modules/
cp tmp/apache/modules/mod_log_config.so     out/server/modules/
cp tmp/apache/modules/mod_mime.so           out/server/modules/
cp tmp/apache/modules/mod_rewrite.so        out/server/modules/
cp tmp/apache/modules/mod_setenvif.so       out/server/modules/

cp tmp/php/license.txt                      out/server/php/php-license.txt
cp tmp/php/libeay32.dll                     out/server/php/ # missing!
cp tmp/php/php7apache2_4.dll                out/server/php/
cp tmp/php/php7ts.dll                       out/server/php/
cp tmp/php/ssleay32.dll                     out/server/php/ # missing!
cp tmp/php/ext/php_bz2.dll                  out/server/php/ext/
cp tmp/php/ext/php_gd2.dll                  out/server/php/ext/
cp tmp/php/ext/php_ldap.dll                 out/server/php/ext/ # support ldap auth
cp tmp/php/ext/php_mbstring.dll             out/server/php/ext/
cp tmp/php/ext/php_openssl.dll              out/server/php/ext/
cp tmp/php/ext/php_pdo_sqlite.dll           out/server/php/ext/
cp tmp/php/libssh2.dll                      out/server/php/ # instead of the missing files?
cp tmp/php/libsasl.dll                      out/server/php/ # needed for ldap?
cp tmp/php/libsodium.dll                    out/server/php/ # needed for ldap?
cp tmp/php/libssl1-1_1-x64.dll              out/server/php/ # needed for ldap?

# compress files
./upx out/server/*.dll
./upx out/server/*.exe
./upx out/server/modules/*.so
./upx out/server/php/ext/*.dll

