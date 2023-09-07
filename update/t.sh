_exec_cmd() {
  printf "==> Executing: %q " "$@"
  printf "\\n"
  xargs -I CMD sh -c 'CMD' _ "$@"
  printf "\\n"
}

_exec_cmd() {
  cmd=$(printf "%q " "$@")
  echo "==> Executing: $cmd"
  eval "$cmd"
  echo
}

function exec_cmd() {
  echo "Executing CMD: $*"
  sh -c "$*" | tee
}

exec_cmd cat > bad.html <<_badhtml
<!DOCTYPE html>
<body>
<h1>My First Heading</h1>
<p>My first paragraph.</p>
_badhtml
