defmodule Homework.UsersTest do
  use Homework.DataCase

  alias Homework.Users
  alias Homework.Companies

  describe "users" do
    alias Homework.Users.User

    @valid_attrs %{dob: "some dob", first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{
      dob: "some updated dob",
      first_name: "some updated first_name",
      last_name: "some updated last_name"
    }
    @invalid_attrs %{dob: nil, first_name: nil, last_name: nil}

    def company_fixture(attrs \\ %{}) do
      valid_attrs = %{available_credit: 42, credit_line: 42, name: "some name"}

      {:ok, company} =
        attrs
        |> Enum.into(valid_attrs)
        |> Companies.create_company()

      company
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/1 returns all users" do
      company = company_fixture()
      user = user_fixture(%{company_id: company.id})
      assert Users.list_users([]) == [user]
    end

    test "get_user!/1 returns the user with given id" do
      company = company_fixture()
      user = user_fixture(%{company_id: company.id})
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      company = company_fixture()

      assert {:ok, %User{} = user} =
               Users.create_user(%{company_id: company.id} |> Enum.into(@valid_attrs))

      assert user.dob == "some dob"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      company = company_fixture()
      user = user_fixture(%{company_id: company.id})

      assert {:ok, %User{} = user} =
               Users.update_user(user, %{company_id: company.id} |> Enum.into(@update_attrs))

      assert user.dob == "some updated dob"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      company = company_fixture()
      user = user_fixture(%{company_id: company.id})
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      company = company_fixture()
      user = user_fixture(%{company_id: company.id})
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      company = company_fixture()
      user = user_fixture(%{company_id: company.id})
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
