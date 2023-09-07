
systemctl stop   apache2
systemctl status apache2
systemctl start  apache2
systemctl status apache2

sleep 15
w3m -dump http://localhost:80 | head -n 10
