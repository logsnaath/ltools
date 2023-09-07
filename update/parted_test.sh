
cd $(dirname $0)
fallocate -l 1G disk.img

partd_cmd="parted --script ./disk.img \
  mktable msdos \
  print \
  mkpart primary 1MiB 200MiB \
  print \
  resizepart 1 500MiB \
  #resize 1 500MiB \
  print \
  rm 1 \
  mklabel gpt \
  print \
  mkpart primary 0 100MiB \
  mkpart primary 100MiB 100% \
  print \
  rm 1 \
  rm 2 \
  print
"
echo "$partd_cmd"
$partd_cmd 
rm -f disk.img


