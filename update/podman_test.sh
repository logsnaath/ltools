exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

exec_cmd podman container create --name test_qamsle registry.suse.com/suse/sle15
exec_cmd podman container list -a
exec_cmd podman stop --latest
exec_cmd podman run -dt -p 8080:80/tcp docker.io/library/httpd
exec_cmd podman ps -a
exec_cmd podman stop --latest
exec_cmd podman rm --latest
exec_cmd podman container list -a
exec_cmd podman rm --all
exec_cmd podman container list -a
