
filename="testfile.txt"

rm -f ${filename}.xz ${filename}.dec XZ*Demo.class
export CLASSPATH=/usr/share/java/xz.jar:.

javac XZDecDemo.java  XZEncDemo.java

echo; echo "Compressing ${filename} to ${filename}.xz"
java XZEncDemo < $filename > ${filename}.xz

echo; echo "Decompressing ${filename}.xz to ${filename}.dec"
java XZDecDemo < ${filename}.xz > ${filename}.dec

orig_sha=$(sha256sum $filename)
new_sha=$(sha256sum ${filename}.dec)

echo;
ls -lhs
rm -f ${filename}.xz ${filename}.dec XZ*Demo.class

echo;
echo "Original shasum: $orig_sha"
echo "New shasum:      $new_sha"

orig_shasum=$(echo $orig_sha | cut -d" " -f1)
new_shasum=$(echo $new_sha | cut -d" " -f1)

echo;
if [ "${orig_shasum}" = "${new_shasum}" ]; then
   echo "PASSED"
else
   echo "FAILED"
fi
