defmodule Homework.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo
  import HomeworkWeb.Pagination

  alias Homework.Companies.Company
  alias Homework.Transactions.Transaction

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies(args) do
    Company
    |> paginated_query(args)
    |> Repo.all()
    |> Enum.map(fn company ->
      # TODO: Use Ecto.Multi to batch these updates
      {:ok, updated_company} = calculate_and_update_available_credit_for_company(company)
      updated_company
    end)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id) do
    company = Repo.get!(Company, id)
    # TODO: Not a huge fan of doing a write during a read, but
    # TODO: doing an update for every transaction isn't ideal either.
    # TODO: Possibly use a postgres trigger instead?
    {:ok, company} = calculate_and_update_available_credit_for_company(company)
    company
  end

  def calculate_and_update_available_credit_for_company(%Company{} = company) do
    available_credit = company.credit_line - calculate_credit_transaction_total_for_company(company)

    # Available credit can only be set directly because it is filtered out of the changeset by design
    company
    |> Company.changeset_available_credit(%{available_credit: available_credit})
    |> Repo.update()
  end

  def calculate_credit_transaction_total_for_company(%Company{} = company) do
    credit_transaction_total = from(t in Transaction,
      where: t.company_id == ^company.id and t.credit == true,
      select: sum(t.amount)
    )
    |> Repo.one!()

    case credit_transaction_total do
      nil -> 0
      _ -> credit_transaction_total
    end
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    # When creating a company for the first time, set the available credit to the credit line
    credit_line = Map.get(attrs, :credit_line, 0)
    attrs = Map.put(attrs, :available_credit, credit_line)

    %Company{}
    |> Company.changeset_available_credit(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    result = company
    |> Company.changeset(attrs)
    |> Repo.update()

    case result do
      {:ok, company} -> calculate_and_update_available_credit_for_company(company)
      {:error, _} -> result
    end

  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end
end
