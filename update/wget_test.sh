cd $(dirname $0)

PROXY=http://invoker.qam.suse.de:3128

wget --no-proxy http://mirror.slitaz.org/iso/rolling/slitaz-rolling.iso

export http_proxy=$PROXY
wget --proxy-user=www --proxy-password=gibsmir http://mirror.slitaz.org/iso/rolling/slitaz-rolling.iso

wget --no-proxy ftp://download.tuxfamily.org/slitaz/boot/slitaz-boot.iso

export ftp_proxy=$PROXY
wget --proxy-user=www --proxy-password=gibsmir ftp://download.tuxfamily.org/slitaz/boot/slitaz-boot.iso
