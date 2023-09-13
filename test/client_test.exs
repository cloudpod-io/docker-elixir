defmodule ClientTest do
  use ExUnit.Case

  test "test multiple docker clients" do
    extra_docker_host = System.get_env("EXTRA_DOCKER_HOST")

    assert extra_docker_host, "Please set EXTRA_DOCKER_HOST to test multiple docker clients"

    default_docker_host_id =
      Docker.Client.client()
      |> Docker.Misc.info()
      |> Map.get("ID")

    extra_docker_host_id =
      Docker.Client.client(host: extra_docker_host)
      |> Docker.Misc.info()
      |> Map.get("ID")

    assert default_docker_host_id != extra_docker_host_id
  end
end
