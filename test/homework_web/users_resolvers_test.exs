defmodule Homework.UsersResolversTest do
  use HomeworkWeb.ConnCase, async: true
  alias Homework.Users
  alias Homework.Companies

  def company_fixture(attrs \\ %{}) do
    valid_attrs = %{available_credit: 42, credit_line: 42, name: "some name"}

    {:ok, company} =
      attrs
      |> Enum.into(valid_attrs)
      |> Companies.create_company()

    company
  end

  @valid_user_attrs %{
    dob: "some dob",
    first_name: "some first_name",
    last_name: "some last_name",
    company_id: Ecto.UUID.bingenerate()
  }
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attrs)
      |> Users.create_user()

    user
  end

  setup do
    company = company_fixture()
    user_fixture(%{first_name: "John", last_name: "Smith", company_id: company.id})
    user_fixture(%{first_name: "John", last_name: "Adams", company_id: company.id})
    user_fixture(%{first_name: "Robert", last_name: "Smith", company_id: company.id})
    :ok
  end

  describe "search for users by first and/or last name" do
    test "last name only" do
      conn = build_conn()

      conn =
        get(conn, "/api",
          query: """
          {
            users(lastName: "mi") {
              results {
                firstName
                lastName
              }
            }
          }
          """
        )

      assert json_response(conn, 200) == %{
               "data" => %{
                 "users" => %{
                   "results" => [
                     %{"firstName" => "John", "lastName" => "Smith"},
                     %{"firstName" => "Robert", "lastName" => "Smith"}
                   ]
                 }
               }
             }
    end

    test "first name only" do
      conn = build_conn()

      conn =
        get(conn, "/api",
          query: """
          {
            users(firstName: "oh") {
              results {
                firstName
                lastName
              }
            }
          }
          """
        )

      assert json_response(conn, 200) == %{
               "data" => %{
                 "users" => %{
                   "results" => [
                     %{"firstName" => "John", "lastName" => "Smith"},
                     %{"firstName" => "John", "lastName" => "Adams"}
                   ]
                 }
               }
             }
    end

    test "first and last name" do
      conn = build_conn()

      conn =
        get(conn, "/api",
          query: """
          {
            users(firstName: "oh",lastName: "mi") {
              results {
                firstName
                lastName
              }
            }
          }
          """
        )

      assert json_response(conn, 200) == %{
               "data" => %{
                 "users" => %{
                   "results" => [
                     %{"firstName" => "John", "lastName" => "Smith"}
                   ]
                 }
               }
             }
    end
  end
end
