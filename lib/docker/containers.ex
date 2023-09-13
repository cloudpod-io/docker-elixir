defmodule Docker.Containers do
  @base_uri "/containers"

  import Docker.Client, only: [client: 0]
  import Kernel, except: [inspect: 2]

  @doc """
  List all existing containers.
  """
  def list(), do: client() |> list()

  def list(client) do
    client
    |> Docker.Client.get("#{@base_uri}/json?all=true")
  end

  @doc """
  Inspect a container by ID.
  """
  def inspect(id), do: client() |> inspect(id)

  def inspect(client, id) do
    client
    |> Docker.Client.get("#{@base_uri}/#{id}/json")
  end

  @doc """
  Stop a running container.
  """
  def stop(id), do: client() |> stop(id)

  def stop(client, id) do
    client
    |> Docker.Client.post("#{@base_uri}/#{id}/stop")
  end

  @doc """
  Remove a container. Assumes the container is already stopped.
  """
  def remove(id), do: client() |> remove(id)

  def remove(client, id) do
    client
    |> Docker.Client.delete("#{@base_uri}/#{id}")
  end

  @doc """
  Create a container from an existing image.
  """
  def create(conf), do: client() |> create(conf)

  def create(client, conf) do
    create(client, conf, nil)
  end

  def create(client, conf, nil) do
    client
    |> Docker.Client.post("#{@base_uri}/create", conf)
  end

  def create(client, conf, name) do
    client
    |> Docker.Client.post("#{@base_uri}/create?name=#{name}", conf)
  end

  @doc """
  Starts a newly created container.
  """
  def start(id), do: client() |> start(id)

  def start(client, id) do
    start(client, id, %{})
  end

  @doc """
  Starts a newly created container with a specified start config.
  The start config was deprecated as of v1.15 of the API, and all
  host parameters should be in the create configuration.
  """
  def start(client, id, conf) do
    client
    |> Docker.Client.post("#{@base_uri}/#{id}/start", conf)
  end
end
