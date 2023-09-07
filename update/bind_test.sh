
systemctl restart named
systemctl status named
echo;

echo "Query result:"
dig @127.0.0.1 localhost +short #+nocookie
dig -t a google.com @127.0.0.1 -p 53 +short #+nocookie
dig -t aaaa google.com @127.0.0.1 -p 53 +short #+nocookie
echo;

echo "Testing clients"
dig -t a @8.8.8.8 suse.com +short
echo "======================================"
