defmodule NoshNetwork.QuotationsTest do
  use NoshNetwork.DataCase

  describe "quotations" do
    alias NoshNetwork.Data.Context.Quotations

    import NoshNetwork.QuotationsFixtures

    @invalid_attrs %{fee: nil, note: nil, reference_id: nil, subtotal: nil, total: nil}

    test "list_quotations/0 returns all quotations" do
      quotation = quotation_fixture()
      assert Quotations.list_quotations() == [quotation]
    end

    test "get_quotation!/1 returns the quotation with given id" do
      quotation = quotation_fixture()
      assert Quotations.get_quotation!(quotation.id) == quotation
    end

    test "create_quotation/1 with valid data creates a quotation" do
      valid_attrs = %{
        fee: "some fee",
        note: "some note",
        reference_id: "some reference_id",
        subtotal: "some subtotal",
        total: "some total"
      }

      assert {:ok, %Quotation{} = quotation} = Quotations.create_quotation(valid_attrs)
      assert quotation.fee == "some fee"
      assert quotation.note == "some note"
      assert quotation.reference_id == "some reference_id"
      assert quotation.subtotal == "some subtotal"
      assert quotation.total == "some total"
    end

    test "create_quotation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quotations.create_quotation(@invalid_attrs)
    end

    test "update_quotation/2 with valid data updates the quotation" do
      quotation = quotation_fixture()

      update_attrs = %{
        fee: "some updated fee",
        note: "some updated note",
        reference_id: "some updated reference_id",
        subtotal: "some updated subtotal",
        total: "some updated total"
      }

      assert {:ok, %Quotation{} = quotation} =
               Quotations.update_quotation(quotation, update_attrs)

      assert quotation.fee == "some updated fee"
      assert quotation.note == "some updated note"
      assert quotation.reference_id == "some updated reference_id"
      assert quotation.subtotal == "some updated subtotal"
      assert quotation.total == "some updated total"
    end

    test "update_quotation/2 with invalid data returns error changeset" do
      quotation = quotation_fixture()
      assert {:error, %Ecto.Changeset{}} = Quotations.update_quotation(quotation, @invalid_attrs)
      assert quotation == Quotations.get_quotation!(quotation.id)
    end

    test "delete_quotation/1 deletes the quotation" do
      quotation = quotation_fixture()
      assert {:ok, %Quotation{}} = Quotations.delete_quotation(quotation)
      assert_raise Ecto.NoResultsError, fn -> Quotations.get_quotation!(quotation.id) end
    end

    test "change_quotation/1 returns a quotation changeset" do
      quotation = quotation_fixture()
      assert %Ecto.Changeset{} = Quotations.change_quotation(quotation)
    end
  end
end
