defmodule Docker.Misc do
  import Docker.Client, only: [client: 0]

  @doc """
  Display system-wide information.
  """
  def info(), do: client() |> info()
  def info(client), do: client |> Docker.Client.get("/info")

  @doc """
  Show the docker version information.
  """
  def version(), do: client() |> version()
  def version(client), do: client |> Docker.Client.get("/version")

  @doc """
  Ping the docker server.
  """
  def ping(), do: client() |> Docker.Client.get("/_ping")
  def ping(client), do: client |> Docker.Client.get("/_ping")

  @doc """
  Monitor Docker's events.
  """
  def events(since), do: client() |> events(since)

  def events(client, since) do
    client
    |> Docker.Client.get("/events?since=#{since}")
  end
end
