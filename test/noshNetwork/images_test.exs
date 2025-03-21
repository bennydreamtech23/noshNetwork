defmodule NoshNetwork.ImagesTest do
  use NoshNetwork.DataCase

  # alias NoshNetwork.Images
  alias NoshNetwork.Data.Context.Images
  alias NoshNetwork.Data.Schema.Image

  describe "images" do
    import NoshNetwork.ImagesFixtures

    @invalid_attrs %{image: nil, title: nil, type: nil}

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Images.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Images.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{image: "some image", title: "some title", type: "some type"}

      assert {:ok, %Image{} = image} = Images.create_image(valid_attrs)
      assert image.image == "some image"
      assert image.title == "some title"
      assert image.type == "some type"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()

      update_attrs = %{
        image: "some updated image",
        title: "some updated title",
        type: "some updated type"
      }

      assert {:ok, %Image{} = image} = Images.update_image(image, update_attrs)
      assert image.image == "some updated image"
      assert image.title == "some updated title"
      assert image.type == "some updated type"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_image(image, @invalid_attrs)
      assert image == Images.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Images.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Images.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Images.change_image(image)
    end
  end
end
