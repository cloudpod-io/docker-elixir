defmodule Docker.Images do
  @base_uri "/images"

  import Docker.Client, only: [client: 0]
  import Kernel, except: [inspect: 2]

  @doc """
  List all Docker images.
  """
  def list(), do: client() |> list()

  def list(client) do
    list(client, nil)
  end

  def list(client, nil) do
    client
    |> Docker.Client.get("#{@base_uri}/json", query: %{all: "true"})
  end

  @doc """
  Return a filtered list of Docker images.
  """
  def list(client, filter) do
    client
    |> Docker.Client.get("#{@base_uri}/json", query: %{filter: filter})
  end

  @doc """
  Inspect a Docker image by name or id.
  """
  def inspect(name), do: client() |> inspect(name)

  def inspect(client, name) do
    client
    |> Docker.Client.get("#{@base_uri}/#{name}/json?all=true")
  end

  @doc """
  Pull a Docker image from the repo.
  """
  def pull(image), do: client() |> pull(image, "latest")

  def pull(image, tag), do: client() |> pull(image, tag)

  def pull(client, image, tag) do
    pull(client, image, tag, nil)
  end

  def pull(client, image, tag, nil) do
    client
    |> Docker.Client.post("#{@base_uri}/create", "", query: %{fromImage: image, tag: tag})
  end

  @doc """
  Pull a Docker image from the repo after authenticating.
  """
  def pull(client, image, tag, auth) do
    auth_header = auth |> Jason.encode!() |> Base.encode64()
    headers = [{"x-registry-auth", auth_header}]

    client
    |> Docker.Client.post("#{@base_uri}/create", "",
      headers: headers,
      query: %{fromImage: image, tag: tag}
    )
  end

  @doc """
  Deletes a local image.
  """
  def delete(image), do: client() |> delete(image)

  def delete(client, image) do
    client
    |> Docker.Client.delete(@base_uri <> "/" <> image)
  end
end
