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
