defmodule HomeworkWeb.Schemas.CompaniesSchema do
  @moduledoc """
  Defines the graphql schema for companies.
  """
  use Absinthe.Schema.Notation
  import HomeworkWeb.Pagination

  alias HomeworkWeb.Resolvers.CompaniesResolver

  paginated_object :company, :companies do
    field(:id, non_null(:id))
    field(:name, :string)
    field(:description, :string)
    field(:credit_line, :integer)
    field(:available_credit, :integer)
  end

  object :company_mutations do
    @desc "Create a new company"
    field :create_company, :company do
      arg(:name, non_null(:string))
      arg(:description, non_null(:string))
      arg(:credit_line, non_null(:integer))

      resolve(&CompaniesResolver.create_company/3)
    end

    @desc "Update a new company"
    field :update_company, :company do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      arg(:description, non_null(:string))
      arg(:credit_line, non_null(:integer))

      resolve(&CompaniesResolver.update_company/3)
    end

    @desc "Delete an existing company"
    field :delete_company, :company do
      arg(:id, non_null(:id))

      resolve(&CompaniesResolver.delete_company/3)
    end
  end
end
