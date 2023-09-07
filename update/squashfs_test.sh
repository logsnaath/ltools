cd $(dirname $0)

mkdir -p mytemp; cd mytemp; rm -rf my_*
cp -r /usr/sbin my_sbin
ls -l my_sbin |head -n10

mksquashfs my_sbin my_sbin_gzip.sqfs
unsquashfs -s my_sbin_gzip.sqfs

mksquashfs my_sbin my_sbin_lzma.sqfs -comp lzma
unsquashfs -s my_sbin_lzma.sqfs

unsquashfs -d my_squashfs_dir my_sbin_lzma.sqfs

ls -l my_squashfs_dir |head -n10

