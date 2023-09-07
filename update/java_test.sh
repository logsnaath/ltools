exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

cd $(dirname $0)
PORT=1234

exec_cmd javac --version
exec_cmd java  --version

cat > HelloWorld.java << _eof
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World");
 }
}
_eof

exec_cmd javac HelloWorld.java

exec_cmd java HelloWorld

cat > SimpleServer.java <<_eof
import java.io.PrintStream;
import java.net.ServerSocket;
import java.net.Socket;

public class SimpleServer {
    public static void main(String[] args) throws Exception {
        if (args.length != 1) {
            System.out.println("Usage: java SimpleServer <port>");
            System.exit(1);
        }

        int port = Integer.parseInt(args[0]);
        ServerSocket ssock = new ServerSocket(port);

        System.out.println("Listening on port " + port);
        Socket sock = ssock.accept();
        ssock.close();

        PrintStream ps = new PrintStream(sock.getOutputStream());
        ps.println("Hello there!");
        ps.close();

        sock.close();
    }
}

_eof

exec_cmd javac SimpleServer.java
exec_cmd java SimpleServer $PORT &
JPID=$!
sleep 2
echo;

exec_cmd nc -w1 localhost 1234

kill $JPID

