defmodule HomeworkWeb.Schema do
  @moduledoc """
  Defines the graphql schema for this project.
  """
  use Absinthe.Schema

  use HomeworkWeb.Pagination

  alias HomeworkWeb.Resolvers.MerchantsResolver
  alias HomeworkWeb.Resolvers.TransactionsResolver
  alias HomeworkWeb.Resolvers.UsersResolver
  alias HomeworkWeb.Resolvers.CompaniesResolver
  import_types(HomeworkWeb.Schemas.Types)

  query do
    @desc "Get all Transactions"
    paginated_field(:transactions) do
      arg(:max, :integer)
      arg(:min, :integer)
      resolve(&TransactionsResolver.transactions/3)
    end

    @desc "Get all Users"
    paginated_field(:users) do
      # TODO: Make first and last name search into an optional union type?
      arg(:first_name, :string)
      arg(:last_name, :string)
      resolve(&UsersResolver.users/3)
    end

    @desc "Get all Merchants"
    paginated_field(:merchants) do
      resolve(&MerchantsResolver.merchants/3)
    end

    @desc "Get all Companies"
    paginated_field(:companies) do
      resolve(&CompaniesResolver.companies/3)
    end
  end

  mutation do
    import_fields(:transaction_mutations)
    import_fields(:user_mutations)
    import_fields(:merchant_mutations)
    import_fields(:company_mutations)
  end
end
