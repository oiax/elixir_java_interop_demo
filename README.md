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

## Usage

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
$ elixir --sname client lib/client.exs
```
