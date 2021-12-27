# Elixir Java Interop Demo

## Installation

```bash
$ git clone https://github.com/oiax/elixir_java_interop_demo.git
$ cd elixir_java_interop_demo
$ git clone https://github.com/erlang/otp.git -b OTP-24.2
$ docker-compose build app
$ docker-compose up -d app
$ docker-compose exec app bash
> ./build.sh
```

## Starting the Java server

```bash
> ./start.sh
```

Here is the source code of this shell script:

```bash
#!/bin/bash
set -eu

epmd -daemon

CLASSPATH=".:/work/otp/lib/jinterface/java_src"
cd java
java -classpath "$CLASSPATH" SimpleServer
```

Note that this starts the [epmd](https://www.erlang.org/doc/man/epmd.html) (Erlang Port Mapper Daemon) beforehand.

## Elixir client

```elixir
{:ok, host} = :inet.gethostname()
java_server = String.to_atom("simpleserver@" <> List.to_string(host))

if Node.ping(java_server) == :pong do
  mbox_name = :mbox
  message = {self(), "ABCD"}
  r = Process.send({mbox_name, java_server}, message, [:noconnect])

  if r == :ok do
    receive do
      n when is_integer(n) -> IO.puts(n)
      msg -> IO.puts(:stderr, "Unexpected message received: #{msg}")
    after
      5000 -> IO.puts(:stderr, "No message in 5 seconds.")
    end
  else
    IO.puts(:stderr, "No connection.")
  end
else
  IO.puts(:stderr, "Server not reachable.")
end
```

This script is available as [client.exs](./lib/client.exs).

You can run it like this:

```
$ docker-compose exec app bash
> elixir --sname client lib/client.exs
```

## Java server

Here is the source code of a simple server written in Java.

```java
import com.ericsson.otp.erlang.OtpAuthException;
import com.ericsson.otp.erlang.OtpNode;
import com.ericsson.otp.erlang.OtpMbox;
import com.ericsson.otp.erlang.OtpErlangObject;
import com.ericsson.otp.erlang.OtpErlangTuple;
import com.ericsson.otp.erlang.OtpErlangPid;
import com.ericsson.otp.erlang.OtpErlangBinary;
import com.ericsson.otp.erlang.OtpErlangInt;

public class SimpleServer {
  static java.lang.String snode = "simpleserver";
  static java.lang.String mboxname = "mbox";
  static java.lang.String cookie = "elixirjava";
  private OtpNode node;
  private OtpMbox mbox;

  public static void main(String[] args) throws Exception {
    SimpleServer server = new SimpleServer(args);
    server.process();
  }

  public SimpleServer(String[] args) throws java.io.IOException {
    node = new OtpNode(snode, cookie);
    mbox = node.createMbox(mboxname);
    System.err.println("Server started.");
  }

  private void process() throws OtpAuthException {
    while (true) {
      try {
        OtpErlangObject msg = mbox.receive();
        OtpErlangTuple t1 = (OtpErlangTuple) msg;
        OtpErlangPid from = (OtpErlangPid) t1.elementAt(0);
        OtpErlangBinary bin = (OtpErlangBinary) t1.elementAt(1);

        OtpErlangInt reply = new OtpErlangInt(bin.size());
        mbox.send(from, reply);
      }
      catch (Exception e) {
        System.err.println("Error accepting connection: " + e);
      }
    }
  }
}
```

This source code is available as [SimpleServer.java](./java/SimpleServer.java).
