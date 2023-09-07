exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

cd $(dirname $0);

exec_cmd wget https://www.wavsource.com/snds_2020-10-01_3728627494378403/sfx/fanfare3.wav -O ff.wav

exec_cmd oggenc ff.wav
exec_cmd ls -al ff*
exec_cmd ogginfo ff.ogg

exec_cmd oggenc -r ff.wav -o ffnew.ogg
exec_cmd oggdec ffnew.ogg
exec_cmd ls -al ff*

