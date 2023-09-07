zypper in autoconf automake libtool

rpm -ivh https://download.suse.de/ibs/SUSE:/Maintenance:/30164/SUSE_Updates_SLE-Module-Basesystem_15-SP4_x86_64/src/qatengine-0.6.10-150400.3.3.1.src.rpm

tar xvf /usr/src/packages/SOURCES/qatengine-*.tar.* -C /tmp

cd /tmp/QAT_Engine-*/
./autogen.sh
./configure
./testapp.sh QAT_SW
./testapp.sh QAT_HW

cat testapp.log

