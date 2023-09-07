exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

## Change to the right rpm
exec_cmd rpm -ivh https://download.suse.de/ibs/SUSE:/Maintenance:/28984/SUSE_Updates_SLE-Module-Desktop-Applications_15-SP4_x86_64/src/libheif-1.12.0-150400.3.11.1.src.rpm

exec_cmd cd /usr/src/packages/SPECS
exec_cmd sed -i 's/-DWITH_EXAMPLES=OFF/-DWITH_EXAMPLES=ON/g' libheif.spec
exec_cmd rpmbuild -ba libheif.spec

exec_cmd cd /usr/src/packages/BUILDROOT/libheif*/usr/bin/
exec_cmd wget -cq https://filesamples.com/samples/image/heif/sample1.heif
exec_cmd ./heif-info sample1.heif

# zypper -n install -y ImageMagick
# ldd `which identify` | grep libheif
# rpm -ql libheif1
# identify sample1.heif
