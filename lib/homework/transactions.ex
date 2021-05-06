defmodule Homework.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  import HomeworkWeb.Pagination
  alias Homework.Repo
  alias Homework.Transactions.Transaction

  @doc """
  Returns the list of transactions given a minimum and/or maximum value.
  If no min or max is given, all transactions are returned.

  ## Examples
      iex> list_transactions([])
      [%Transaction{}, ...]
  """
  def list_transactions(%{min: min, max: max} = args) do
    Transaction
    |> where([t], t.amount >= ^min)
    |> where([t], t.amount <= ^max)
    |> paginated_query(args)
    |> Repo.all()
  end

  def list_transactions(%{min: min} = args) do
    Transaction
    |> where([t], t.amount >= ^min)
    |> paginated_query(args)
    |> Repo.all()
  end

  def list_transactions(%{max: max} = args) do
    Transaction
    |> where([t], t.amount <= ^max)
    |> paginated_query(args)
    |> Repo.all()
  end

  def list_transactions(args) do
    Transaction
    |> paginated_query(args)
    |> Repo.all()
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
