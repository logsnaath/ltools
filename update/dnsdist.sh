

reset_conf () {
   \mv /etc/dnsdist/dnsdist.conf-orig /etc/dnsdist/dnsdist.conf
}

mv /etc/dnsdist/dnsdist.conf /etc/dnsdist/dnsdist.conf-orig 
trap reset_conf 0

cat << _EOF > /etc/dnsdist/dnsdist.conf
addLocal("127.0.0.1:53")
newServer{address="8.8.8.8:53"}
newServer{address="8.8.4.4:53"}
newServer({address="2001:db8::1", qps=1})
newServer({address="[2001:db8::3]:5300", qps=10})
newServer({address="2001:db8::4", name="dns1", qps=10})
newServer("9.9.9.9")
setServerPolicy(firstAvailable) -- first server within its QPS limit
_EOF

set -x
systemctl restart dnsdist.service

systemctl status dnsdist.service

dom="google.com"
echo; echo "Results for: $dom"
dig -t a $dom @127.0.0.1 -p 53 +short +nocookie
dig -t aaaa $dom @127.0.0.1 -p 53 +short +nocookie

