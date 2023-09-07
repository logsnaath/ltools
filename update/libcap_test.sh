check_liblink () {
  rpm -qf $(ldd $(which $@) | awk '/libcap/{print $3}')
}

assert_null () {
  if [ -z "$1" ]; then
    echo "PASS"
  else
    echo "FAIL"
    echo "    NOT_NULL => $1"
  fi
}

assert_equal () {
  if [ "$1" = "$2" ]; then
    echo "PASS";
  else
    echo "FAIL";
    echo "    NOT_EQUAL => str1=$1 str2=$2"
  fi
}

assert_match () {
  mesg=$1
  shift;
  if echo "$mesg" | grep "$@"; then
     echo "PASS"
  else
     echo "FAIL"
     echo "    NO_MATCH => match_str=$@, mesg=$mesg"
  fi
}

getcap_val () {
  getcap $1 | awk '{print $3}'
}

user_del () {
   userdel -r testme
}

file_name=test_$(date +%s)

check_liblink getcap
check_liblink setcap

echo hi > $file_name
assert_null $(getcap $file_name)

cap="cap_net_raw+ep"
setcap $cap $file_name
assert_equal $cap $(getcap_val $file_name)

setcap -r $file_name
assert_null $(getcap $file_name)

pingcap=$(getcap /usr/bin/ping)
useradd -m -G users -s /bin/bash testme
trap user_del 0

sudo -u testme cp /usr/bin/ping /home/testme/
user_pingcap=$(getcap /home/testme/ping)
#setcap -r /home/testme/ping
echo "Original ping cap: $pingcap"
echo "Users ping cap: $user_pingcap"

mesg=$(sudo -u testme /home/testme/ping -c 2 google.com 2>&1)

assert_match "$mesg" "Operation not permitted" 

assert_null $(getcap /home/testme/ping)

cap="cap_net_raw+ep"
setcap $cap /home/testme/ping

assert_equal $cap $(getcap_val /home/testme/ping)

pingval=$(sudo -u testme /home/testme/ping -c 2 google.com)
assert_match "$pingval" "bytes from"


