
cd $(dirname $0)

zypper -n in gcc mariadb-server

gcc libmariadb_test.c -o libmariadb_test -lmariadb

./libmariadb_test -h localhost -u root -p ''
