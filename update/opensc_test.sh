
exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

exec_cmd opensc-tool -i
exec_cmd opensc-tool -D

exec_cmd cryptoflex-tool -l
exec_cmd cryptoflex-tool -g

