defmodule NoshNetwork.GallerysTest do
  use NoshNetwork.DataCase

  alias NoshNetwork.Gallerys

  describe "galleries" do
    alias NoshNetwork.Data.Context.Images.Gallery

    import NoshNetwork.GallerysFixtures

    @invalid_attrs %{gallery_name: nil, is_deleted: nil}

    test "list_galleries/0 returns all galleries" do
      gallery = gallery_fixture()
      assert Gallerys.list_galleries() == [gallery]
    end

    test "get_gallery!/1 returns the gallery with given id" do
      gallery = gallery_fixture()
      assert Gallerys.get_gallery!(gallery.id) == gallery
    end

    test "create_gallery/1 with valid data creates a gallery" do
      valid_attrs = %{gallery_name: "some gallery_name", is_deleted: true}

      assert {:ok, %Gallery{} = gallery} = Gallerys.create_gallery(valid_attrs)
      assert gallery.gallery_name == "some gallery_name"
      assert gallery.is_deleted == true
    end

    test "create_gallery/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gallerys.create_gallery(@invalid_attrs)
    end

    test "update_gallery/2 with valid data updates the gallery" do
      gallery = gallery_fixture()
      update_attrs = %{gallery_name: "some updated gallery_name", is_deleted: false}

      assert {:ok, %Gallery{} = gallery} = Gallerys.update_gallery(gallery, update_attrs)
      assert gallery.gallery_name == "some updated gallery_name"
      assert gallery.is_deleted == false
    end

    test "update_gallery/2 with invalid data returns error changeset" do
      gallery = gallery_fixture()
      assert {:error, %Ecto.Changeset{}} = Gallerys.update_gallery(gallery, @invalid_attrs)
      assert gallery == Gallerys.get_gallery!(gallery.id)
    end

    test "delete_gallery/1 deletes the gallery" do
      gallery = gallery_fixture()
      assert {:ok, %Gallery{}} = Gallerys.delete_gallery(gallery)
      assert_raise Ecto.NoResultsError, fn -> Gallerys.get_gallery!(gallery.id) end
    end

    test "change_gallery/1 returns a gallery changeset" do
      gallery = gallery_fixture()
      assert %Ecto.Changeset{} = Gallerys.change_gallery(gallery)
    end
  end
end
