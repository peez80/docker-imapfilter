#!/bin/sh
apk add --no-cache \
    openssl openssl-dev make lua5.3 lua-dev pcre pcre-dev alpine-sdk


wget https://github.com/lefcha/imapfilter/archive/master.zip
unzip master.zip
cd imapfilter-master

make all
make install

apk del alpine-sdk

cd ..
rm -r imapfilter-master
rm master.zip