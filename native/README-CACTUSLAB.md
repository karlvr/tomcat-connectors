Build on Ubuntu:

```shell
apt-get install apache2-dev build-essential libtool-bin
./buildconf.sh
./configure --with-apxs=/usr/bin/apxs2
make clean
make
cp apache-2.0/mod_jk.so /usr/lib/apache2/modules
apt-get remove apache2-dev build-essential libtool-bin
apt-get autoremove
```
