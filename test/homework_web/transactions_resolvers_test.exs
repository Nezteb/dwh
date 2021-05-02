defmodule Homework.ResolversTest do
  use HomeworkWeb.ConnCase, async: true
  alias Homework.Merchants
  alias Homework.Transactions
  alias Homework.Users

  def transaction_fixture(valid_attrs, attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(valid_attrs)
      |> Transactions.create_transaction()

    transaction
  end

  setup do
    {:ok, merchant1} =
      Merchants.create_merchant(%{description: "some description", name: "some name"})

    {:ok, merchant2} =
      Merchants.create_merchant(%{
        description: "some updated description",
        name: "some updated name"
      })

    {:ok, user1} =
      Users.create_user(%{
        dob: "some dob",
        first_name: "some first_name",
        last_name: "some last_name"
      })

    {:ok, user2} =
      Users.create_user(%{
        dob: "some updated dob",
        first_name: "some updated first_name",
        last_name: "some updated last_name"
      })

    valid_attrs = %{
      amount: 42,
      credit: true,
      debit: true,
      description: "some description",
      merchant_id: merchant1.id,
      user_id: user1.id
    }

    transaction_fixture(valid_attrs, %{amount: 1})
    transaction_fixture(valid_attrs, %{amount: 5})
    transaction_fixture(valid_attrs, %{amount: 10})
    transaction_fixture(valid_attrs, %{amount: 100})
    :ok
  end

  describe "transactions with min and/or max value" do
    test "min only" do
      conn = build_conn()
      conn = get conn, "/api", query: """
      {
        transactions(min: 4) {
          amount
        }
      }
      """

      assert json_response(conn, 200) == %{"data" =>
        %{"transactions" => [
          %{"amount" => 5},
          %{"amount" => 10},
          %{"amount" => 100}
        ]}
      }
    end

    test "max only" do
      conn = build_conn()
      conn = get conn, "/api", query: """
      {
        transactions(max: 60) {
          amount
        }
      }
      """

      assert json_response(conn, 200) == %{"data" =>
        %{"transactions" => [
          %{"amount" => 1},
          %{"amount" => 5},
          %{"amount" => 10}
        ]}
      }
    end

    test "min and max" do
      conn = build_conn()
      conn = get conn, "/api", query: """
      {
        transactions(min: 6, max: 99) {
          amount
        }
      }
      """

      assert json_response(conn, 200) == %{"data" =>
        %{"transactions" => [
          %{"amount" => 10}
        ]}
      }
    end
  end
end
