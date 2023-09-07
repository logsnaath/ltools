
if [ -z "$LHOST" -o -z "$RHOST" ]; then
   echo "Set these two env"
   echo "export LHOST="
   echo "export RHOST="
   exit 1
fi

mkdir backup-ipsec
cp -r /etc/ipsec.d /etc/ipsec.conf /etc/ipsec.secrets ~/backup-ipsec

tmpdir=/tmp/temp
rm -rf /tmp/temp
mkdir -p $tmpdir; cd $tmpdir

mkdir -p ipsec.d/{private,certs,cacerts,run} lhost rhost;
ipsec pki --gen > caKey.der
ipsec pki --self --in caKey.der --dn "CN=swtest" --ca > ipsec.d/cacerts/caCert.der

ipsec pki --gen > ipsec.d/private/${LHOST}Key.der
ipsec pki --pub --in ipsec.d/private/${LHOST}Key.der | ipsec pki --issue --cacert ipsec.d/cacerts/caCert.der --cakey caKey.der --dn "CN=${LHOST}" > ipsec.d/certs/${LHOST}Cert.der

ipsec pki --gen > ipsec.d/private/${RHOST}Key.der
ipsec pki --pub --in ipsec.d/private/${RHOST}Key.der | ipsec pki --issue --cacert ipsec.d/cacerts/caCert.der --cakey caKey.der --dn "CN=${RHOST}" > ipsec.d/certs/${RHOST}Cert.der

cat > lhost/ipsec.conf <<_eof
config setup

conn %default
    ikelifetime=60m
    keylife=20m
    rekeymargin=3m
    keyingtries=1
    keyexchange=ikev2

conn host-host
    auto=add
    left=${LHOST}
    leftcert=${LHOST}Cert.der
    leftid="CN=${LHOST}"
    right=${RHOST}
    rightcert=${RHOST}Cert.der
    rightid="CN=${RHOST}"
    rightsendcert=never

_eof

cat > lhost/ipsec.secrets <<_eof
: RSA ${LHOST}Key.der
_eof

cat > rhost/ipsec.conf <<_eof
config setup

conn %default
    ikelifetime=60m
    keylife=20m
    rekeymargin=3m
    keyingtries=1
    keyexchange=ikev2

conn host-host
    auto=add
    right=${LHOST}
    rightcert=${LHOST}Cert.der
    rightid="CN=${LHOST}"
    left=${RHOST}
    leftcert=${RHOST}Cert.der
    leftid="CN=${RHOST}"
    rightsendcert=never
_eof

cat > rhost/ipsec.secrets <<_eof
: RSA ${RHOST}Key.der
_eof

## remote
echo; echo "==> Teardown Remote side"
ssh ${RHOST} '
    ipsec down host-host;
    ipsec stop;
    killall charon;
    rm -rf /etc/ipsec.*;
'

## local
echo; echo "==> Teardown Local side"
ipsec down host-host
ipsec stop
killall charon
rm -rf /etc/ipsec.*


## Remote
echo; echo "==> Bring up Remote side"
tar cvf - rhost/ipsec.* ipsec.d | ssh ${RHOST} '
    tar xvf - -C /etc/;
    mv /etc/rhost/* /etc/;
    rmdir /etc/rhost;
    firewall-cmd --add-port=500/udp --add-port=4500/udp;
    ipsec start;
'

## Local
echo; echo "==> Bring up Local side"
cp lhost/ipsec.* /etc
cp -r ipsec.d /etc/
firewall-cmd --add-port=500/udp --add-port=4500/udp

ipsec start
sleep 5
ipsec up host-host
ipsec statusall;

