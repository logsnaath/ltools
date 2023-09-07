exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

#cd $(dirname $0);
cd /tmp; rm -rf rust_app

#rustup show
#rustup check
#rustup completions bash > /dev/null; echo $?

exec_cmd pwd
exec_cmd cargo new rust_app
exec_cmd cd rust_app;
exec_cmd pwd
exec_cmd ls

cat > src/main.rs << _EOF
fn main() {
    println!("Hello RUST!, Good to see you!");
}
_EOF

exec_cmd cat src/main.rs
exec_cmd cargo build
exec_cmd cargo run

