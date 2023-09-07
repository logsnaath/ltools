exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

exec_cmd python2 -m pip list
exec_cmd python2 -m pip install pip-install-test;
exec_cmd export PYTHONPATH=/usr/lib/python2.7/site-packages
exec_cmd python2 -c 'import pip_install_test';

exec_cmd python2 -m pip wheel --wheel-dir=/tmp/wheelhouse pip-install-test
exec_cmd python2 -m pip uninstall -y pip-install-test
exec_cmd python2 -m pip install --no-index --find-links=/tmp/wheelhouse pip-install-test
