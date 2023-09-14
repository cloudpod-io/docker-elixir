defmodule Docker.Auth do
  @default_server "https://index.docker.io/v1/"

  import Docker.Client, only: [client: 0]

  @doc """
  Authenticate to the Docker registry.
  """
  def login(
        credentials = %{
          "email" => _email,
          "password" => _password,
          "username" => _username,
          "serveraddress" => _server
        }
      ) do
    client() |> login(credentials)
  end

  def login(
        client,
        credentials = %{
          "email" => _email,
          "password" => _password,
          "username" => _username,
          "serveraddress" => _server
        }
      ) do
    data = Jason.encode!(credentials)

    client
    |> Docker.Client.post("/auth", data)
  end

  def login(client, credentials) do
    login(
      client,
      credentials
      |> Map.put("serveraddress", @default_server)
    )
  end
end
