
systemctl stop   tomcat
systemctl status tomcat
systemctl start  tomcat
systemctl status tomcat

sleep 15
w3m -dump http://localhost:8080 | head -n 10
