exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

exec_cmd pip3 list
exec_cmd pip3 install pip-install-test;
exec_cmd export PYTHONPATH=/usr/lib/python3.11/site-packages
exec_cmd python3 -c 'import pip_install_test';

exec_cmd pip3 wheel --wheel-dir=/tmp/wheelhouse pip-install-test
exec_cmd pip3 uninstall -y pip-install-test
exec_cmd pip3 install --no-index --find-links=/tmp/wheelhouse pip-install-test

