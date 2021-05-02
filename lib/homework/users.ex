defmodule Homework.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users([])
      [%User{}, ...]

  """
  def list_users(_args) do
    Repo.all(User)
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
  Gets all users by their first and last names via fuzzy search.
  """
  def search_for_users(%{first_name: first_name, last_name: last_name}) do
    first_name_wildcard = "%#{first_name}%"
    last_name_wildcard = "%#{last_name}%"

    from(u in User,
      where: like(u.first_name, ^first_name_wildcard) and like(u.last_name, ^last_name_wildcard)
    ) |> Repo.all
  end

  @doc """
  Gets all users by their first name via fuzzy search.
  """
  def search_for_users(%{first_name: first_name}) do
    first_name_wildcard = "%#{first_name}%"

    from(u in User,
      where: like(u.first_name, ^first_name_wildcard)
    ) |> Repo.all
  end

  @doc """
  Gets all users by their last name via fuzzy search.
  """
  def search_for_users(%{last_name: last_name}) do
    last_name_wildcard = "%#{last_name}%"

    from(u in User,
      where: like(u.last_name, ^last_name_wildcard)
    ) |> Repo.all
  end

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
