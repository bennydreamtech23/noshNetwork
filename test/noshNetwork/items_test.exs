defmodule NoshNetwork.ItemsTest do
  use NoshNetwork.DataCase

  alias NoshNetwork.Items

  describe "items" do
    alias NoshNetwork.Items.Item

    import NoshNetwork.ItemsFixtures

    @invalid_attrs %{description: nil, name: nil, price: nil, quantity: nil, subtotal: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Items.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Items.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{description: "some description", name: "some name", price: "some price", quantity: 42, subtotal: "some subtotal"}

      assert {:ok, %Item{} = item} = Items.create_item(valid_attrs)
      assert item.description == "some description"
      assert item.name == "some name"
      assert item.price == "some price"
      assert item.quantity == 42
      assert item.subtotal == "some subtotal"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name", price: "some updated price", quantity: 43, subtotal: "some updated subtotal"}

      assert {:ok, %Item{} = item} = Items.update_item(item, update_attrs)
      assert item.description == "some updated description"
      assert item.name == "some updated name"
      assert item.price == "some updated price"
      assert item.quantity == 43
      assert item.subtotal == "some updated subtotal"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Items.update_item(item, @invalid_attrs)
      assert item == Items.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Items.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Items.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Items.change_item(item)
    end
  end
end
