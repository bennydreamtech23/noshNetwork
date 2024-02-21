defmodule NoshNetwork.Data.Context.CatersTest do
  use NoshNetwork.DataCase

  alias NoshNetwork.Data.Context.Caters

  describe "caters" do
    alias NoshNetwork.Data.Context.Caters.Cater

    import NoshNetwork.Data.Context.CatersFixtures

    @invalid_attrs %{about: nil, gallery: nil, social_media: nil}

    test "list_caters/0 returns all caters" do
      cater = cater_fixture()
      assert Caters.list_caters() == [cater]
    end

    test "get_cater!/1 returns the cater with given id" do
      cater = cater_fixture()
      assert Caters.get_cater!(cater.id) == cater
    end

    test "create_cater/1 with valid data creates a cater" do
      valid_attrs = %{about: "some about", gallery: %{}, social_media: %{}}

      assert {:ok, %Cater{} = cater} = Caters.create_cater(valid_attrs)
      assert cater.about == "some about"
      assert cater.gallery == %{}
      assert cater.social_media == %{}
    end

    test "create_cater/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Caters.create_cater(@invalid_attrs)
    end

    test "update_cater/2 with valid data updates the cater" do
      cater = cater_fixture()
      update_attrs = %{about: "some updated about", gallery: %{}, social_media: %{}}

      assert {:ok, %Cater{} = cater} = Caters.update_cater(cater, update_attrs)
      assert cater.about == "some updated about"
      assert cater.gallery == %{}
      assert cater.social_media == %{}
    end

    test "update_cater/2 with invalid data returns error changeset" do
      cater = cater_fixture()
      assert {:error, %Ecto.Changeset{}} = Caters.update_cater(cater, @invalid_attrs)
      assert cater == Caters.get_cater!(cater.id)
    end

    test "delete_cater/1 deletes the cater" do
      cater = cater_fixture()
      assert {:ok, %Cater{}} = Caters.delete_cater(cater)
      assert_raise Ecto.NoResultsError, fn -> Caters.get_cater!(cater.id) end
    end

    test "change_cater/1 returns a cater changeset" do
      cater = cater_fixture()
      assert %Ecto.Changeset{} = Caters.change_cater(cater)
    end
  end
end
