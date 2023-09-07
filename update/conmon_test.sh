
exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

#cd $(dirname $0);
# podman container create --name test_sle registry.suse.com/suse/sle15
# podman image ls
# podman container start test_sle

exec_cmd podman run -d --name test_sle registry.suse.com/suse/sle15:latest yes
#exec_cmd podma ps -a
exec_cmd podman container ls -a
sleep 5
 
echo "==> Executing: ps auxw | grep conmon" 
ps auxw | grep conmon

echo "==> Executing: journalctl |grep conmon"
journalctl |grep conmon

exec_cmd podman rm -vf test_sle
#exec_cmd podman rm --latest
sleep 5

exec_cmd podman container ls -a
echo "==> Executing: ps auxw | grep conmon"
ps auxw | grep conmon
