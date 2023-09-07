
cd $(dirname $0)

cat > dbopen.py << _DB_OPEN
#!/usr/bin/python

try:
    from bsddb3 import db                   # the Berkeley db data base
except:
    from bsddb import db        #Python2 hangling

# Part 1: Create database and insert 4 elements
#
filename = 'fruit'

# Get an instance of BerkeleyDB 
fruitDB = db.DB()
# Create a database in file "fruit" with a Hash access method
# 	There are also, B+tree and Recno access methods
fruitDB.open(filename, None, db.DB_HASH, db.DB_CREATE)

# Print version information
print(db.DB_VERSION_STRING)

# Insert new elements in database 
fruitDB.put(b'apple',b'red')
fruitDB.put(b"orange",b"orange")
fruitDB.put(b"banana",b"yellow")
fruitDB.put(b"tomato",b"red")

# Close database
fruitDB.close()

# Part 2: Open database and write its contents out
#
fruitDB = db.DB()
# Open database
#	Access method: Hash
#	set isolation level to "dirty read (read uncommited)"
fruitDB.open(filename, None, db.DB_HASH, db.DB_DIRTY_READ)

# get database cursor and print out database content
cursor = fruitDB.cursor()
rec = cursor.first()
while rec:
        print(rec)
        rec = cursor.next()
fruitDB.close()
_DB_OPEN

cat > bdb_rw.c <<_BDB_EX
// https://cxwangyi.wordpress.com/2010/10/10/how-to-use-berkeley-db/
#include <stdlib.h>
#include <string.h>
 
#include <iostream>
#include <iomanip>
#include <string>
#define HAVE_CXX_STDHEADERS
#include <db_cxx.h>
 
using namespace std;
 
const char* kDatabaseName = "access.db";
 
int main() {
  DB *dbp;
  DBT key, data;
  int ret, t_ret;
 
  if ((ret = db_create(&dbp, NULL, 0)) != 0) {
    cerr << "db_create:" << db_strerror(ret) << endl;
    exit (1);
  }
 
  if ((ret = dbp->open(dbp, NULL, kDatabaseName, "",
                       DB_BTREE, DB_CREATE, 0664)) != 0) {
    dbp->err(dbp, ret, "%s", kDatabaseName);
    goto err;
  }
 
  memset(&key, 0, sizeof(key));
  memset(&data, 0, sizeof(data));
  key.data = (char*)"fruit";
  key.size = sizeof("fruit");
  data.data = (char*)"apple";
  data.size = sizeof("apple");
 
  if ((ret = dbp->put(dbp, NULL, &key, &data, 0)) == 0)
    cout << "db: " << (char*)key.data << ": key stored.\n";
  else {
    dbp->err(dbp, ret, "DB->put");
    goto err;
  }
 
  if ((ret = dbp->get(dbp, NULL, &key, &data, 0)) == 0)
    cout << "db: " << (char*)key.data
         << ": key retrieved: data was " << (char *)data.data << endl;
  else {
    dbp->err(dbp, ret, "DB->get");
    goto err;
  }
 
  if ((ret = dbp->del(dbp, NULL, &key, 0)) == 0)
    cout << "db: " << (char*)key.data << " key was deleted.\n";
  else {
    dbp->err(dbp, ret, "DB->del");
    goto err;
  }
 
  if ((ret = dbp->get(dbp, NULL, &key, &data, 0)) == 0)
    cout << "db: " << (char*)key.data << ": key retrieved: data was "
         << (char *)data.data << endl;
  else
    dbp->err(dbp, ret, "DB->get");
 
err:
  if ((t_ret = dbp->close(dbp, 0)) != 0 && ret == 0)
    ret = t_ret;
 
  return ret;
}
_BDB_EX

ex () {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  echo;
}

ex pip3 install bsddb3
ex python3 dbopen.py
ex db_dump -p fruit

ex g++ -ldb bdb_rw.c -ldb -o bdb_rw
ex ./bdb_rw

awk -F: '{print $1; print $0}' < /etc/passwd | sed 's/\\/\\\\/g' | db_load -T -t hash passwd.db
ex db_dump passwd.db
db_verify passwd.db && echo "DB is fine" || echo 'DB verification FAILED' 
