exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

##  Get rar binary
wget -cq https://www.rarlab.com/rar/rarlinux-x64-624.tar.gz
tar xf rarlinux-x64-624.tar.gz

## 1
echo; echo  "1. Create and extract simple archive"
echo "Test rar" > smallfile.txt
exec_cmd ./rar/rar a small.rar smallfile.txt
rm smallfile.txt
exec_cmd unar small.rar
cat smallfile.txt

## 2
echo; echo "2. Create and extract a password protected archive"
exec_cmd ./rar/rar -pmysecret a pprotect-smallfile.rar  smallfile.txt
rm  smallfile.txt
exec_cmd unar -f -p mysecret pprotect-smallfile.rar
cat smallfile.txt

## 3
echo; echo "3. Create a multipart archive and extract"
rm -f multipart.rar multipart.part*.rar 
wget -cq https://www.gutenberg.org/cache/epub/72206/pg72206.txt
exec_cmd ./rar/rar -v100k a multipart.rar pg72206.txt
rm pg72206.txt
exec_cmd unar multipart.part01.rar

## 4
echo; echo "4. Create a password protected multipart archive and extract it"
rm -f pp-multipart.rar pp-multipart.part*.rar
exec_cmd ./rar/rar -pfoo -v200k a pp-multipart.rar  pg72206.txt
rm -f pg72206.txt
exec_cmd unar -f -p foo pp-multipart.part01.rar

## 5
echo; echo "5. Create large archive and extract it"
wget -cq https://download.opensuse.org/distribution/leap/15.0/iso/openSUSE-Leap-15.0-DVD-x86_64-Current.iso
cksum openSUSE-Leap-15.0-DVD-x86_64-Current.iso
exec_cmd ./rar/rar a large-file.rar openSUSE-Leap-15.0-DVD-x86_64-Current.iso
mv openSUSE-Leap-15.0-DVD-x86_64-Current.iso suse.iso
exec_cmd unar -f large-file.rar
cksum openSUSE-Leap-15.0-DVD-x86_64-Current.iso


