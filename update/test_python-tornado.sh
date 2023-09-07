cd $(dirname $0);
echo "Python 2"
nohup python2 test_python-tornado.py --port 8888 &
sleep 2
curl -sk http://localhost:8888

echo;
echo "Python 3"
nohup python3 test_python-tornado.py --port 8889 &
sleep 2
curl -sk http://localhost:8889

exit

