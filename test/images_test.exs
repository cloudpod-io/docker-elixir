defmodule ImagesTest do
  use ExUnit.Case

  @test_image "busybox"
  @test_image_tag "latest"

  setup_all do
    IO.puts("Pulling #{@test_image}:#{@test_image_tag} for testing...")
    Docker.Images.pull(@test_image, @test_image_tag)
    :ok
  end

  test "list images" do
    images = Docker.Images.list()
    assert is_list(images)

    test_image_exists? =
      images
      |> Enum.map(&Map.get(&1, "RepoTags", []))
      |> List.flatten()
      |> Enum.member?("#{@test_image}:#{@test_image_tag}")

    assert test_image_exists?
  end

  test "inspect image" do
    image = Docker.Images.inspect(@test_image)
    assert image
  end
end
