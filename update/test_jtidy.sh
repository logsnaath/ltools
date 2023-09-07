cd $(dirname $0)

exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  echo;
}

cat > jtidy_bad.html <<_badhtml
<!DOCTYPE html> <body> <h1>My First Heading</h1> <p>My first paragraph.</p>
_badhtml

exec_cmd cat jtidy_bad.html 
echo "==> Executing: java -jar /usr/share/java/jtidy.jar jtidy_bad.html > tidy.html"
java -jar /usr/share/java/jtidy.jar jtidy_bad.html > tidy.html

sleep 2
exec_cmd cat tidy.html 
rm -f jtidy_bad.html tidy.html
