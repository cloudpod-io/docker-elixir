defmodule ClientTest do
  use ExUnit.Case

  @socket_path "unix:///var/run/docker.sock"

  test "test explicit host defined client" do
    ping =
      Docker.Client.client(host: @socket_path)
      |> Docker.Misc.ping()

    assert ping == "OK"
  end
end
