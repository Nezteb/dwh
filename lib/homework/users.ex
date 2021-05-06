defmodule Homework.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  import HomeworkWeb.Pagination
  alias Homework.Repo
  alias Homework.Users.User

  @doc """
  Gets all users by their first and/or last names via fuzzy search.
  If no first or last name is given, all users are returned.

  ## Examples
      iex> list_users([])
      [%User{}, ...]
  """
  def list_users(%{first_name: first_name, last_name: last_name} = args) do
    first_name_wildcard = "%#{first_name}%"
    last_name_wildcard = "%#{last_name}%"

    User
    |> where([u], like(u.first_name, ^first_name_wildcard))
    |> where([u], like(u.last_name, ^last_name_wildcard))
    |> paginated_query(args)
    |> Repo.all()
  end

  def list_users(%{first_name: first_name} = args) do
    first_name_wildcard = "%#{first_name}%"

    User
    |> where([u], like(u.first_name, ^first_name_wildcard))
    |> paginated_query(args)
    |> Repo.all()
  end

  def list_users(%{last_name: last_name} = args) do
    last_name_wildcard = "%#{last_name}%"

    User
    |> where([u], like(u.last_name, ^last_name_wildcard))
    |> paginated_query(args)
    |> Repo.all()
  end

  def list_users(args) do
    User
    |> paginated_query(args)
    |> Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
