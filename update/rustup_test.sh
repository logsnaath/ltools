exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

#cd $(dirname $0);
cd /tmp; rm -rf rust_app

exec_cmd rustup show
exec_cmd rustup check

rustup completions bash > /dev/null; echo $?


