{:ok, host} = :inet.gethostname()
java_server = String.to_atom("simpleserver@" <> List.to_string(host))

r = :net_adm.ping(java_server)
IO.inspect r

mbox_name = :mbox
message = {self(), "ABCD"}
r = Process.send({mbox_name, java_server}, message, [:noconnect])
IO.inspect r

receive do
  n when is_integer(n) -> IO.puts(n)
  msg -> IO.puts(:stderr, "Unexpected message received: #{msg}")
after
  5000 -> IO.puts(:stderr, "No message in 5 seconds")
end
