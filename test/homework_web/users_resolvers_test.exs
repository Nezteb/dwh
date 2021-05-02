defmodule Homework.UsersResolversTest do
  use HomeworkWeb.ConnCase, async: true
  alias Homework.Users

  @valid_user_attrs %{dob: "some dob", first_name: "some first_name", last_name: "some last_name"}
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attrs)
      |> Users.create_user()
    user
  end

  setup do
    user_fixture(%{first_name: "John", last_name: "Smith"})
    user_fixture(%{first_name: "John", last_name: "Adams"})
    user_fixture(%{first_name: "Robert", last_name: "Smith"})
    :ok
  end

  describe "search for users by first and/or last name" do
    test "last name only" do
      conn = build_conn()
      conn = get conn, "/api", query: """
      {
        users(lastName: "mi") {
          firstName
          lastName
        }
      }
      """

      assert json_response(conn, 200) == %{"data" =>
        %{"users" => [
          %{"firstName" => "John", "lastName" => "Smith"},
          %{"firstName" => "Robert", "lastName" => "Smith"}
        ]}
      }
    end

    test "first name only" do
      conn = build_conn()
      conn = get conn, "/api", query: """
      {
        users(firstName: "oh") {
          firstName
          lastName
        }
      }
      """

      assert json_response(conn, 200) == %{"data" =>
        %{"users" => [
          %{"firstName" => "John", "lastName" => "Smith"},
          %{"firstName" => "John", "lastName" => "Adams"}
        ]}
      }
    end

    test "first and last name" do
      conn = build_conn()
      conn = get conn, "/api", query: """
      {
        users(firstName: "oh",lastName: "mi") {
          firstName
          lastName
        }
      }
      """

      assert json_response(conn, 200) == %{"data" =>
        %{"users" => [
          %{"firstName" => "John", "lastName" => "Smith"}
        ]}
      }
    end
  end
end
