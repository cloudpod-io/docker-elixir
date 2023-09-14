defmodule Docker.Client do
  @socket_path "unix:///var/run/docker.sock"
  @default_version "v1.36"

  defp get_host(),
    do: Application.get_env(:docker, :host) || System.get_env("DOCKER_HOST", @socket_path)

  defp get_version(), do: Application.get_env(:docker, :version, @default_version)

  defp normalize_host("tcp://" <> host), do: "http://" <> host
  defp normalize_host("unix://" <> host), do: "http+unix://" <> URI.encode_www_form(host)

  defp base_url(), do: base_url(get_host(), get_version())

  defp base_url(host, version) do
    "#{normalize_host(host)}/#{version}"
    |> String.trim_trailing("/")
  end

  def client(), do: client(base_url())

  def client(opts) when is_list(opts) do
    host = Keyword.get(opts, :host, get_host())
    version = Keyword.get(opts, :version, get_version())

    base_url(host, version)
    |> client()
  end

  def client(base_url) when is_binary(base_url) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Docker.ChunkedJson
    ]

    Tesla.client(middleware, Tesla.Adapter.Hackney)
  end

  @doc """
  Send a GET request to the Docker API at the speicifed resource.
  """
  def get(client, resource, opts \\ []) do
    Tesla.get!(client, resource, opts) |> Map.get(:body)
  end

  @doc """
  Send a POST request to the Docker API, JSONifying the passed in data.
  """
  def post(client, resource, data \\ %{}, opts \\ []) do
    Tesla.post!(client, resource, data, opts) |> Map.get(:body)
  end

  @doc """
  Send a DELETE request to the Docker API.
  """
  def delete(client, resource, opts \\ []) do
    Tesla.delete!(client, resource, opts)
  end
end
