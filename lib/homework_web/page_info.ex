defmodule HomeworkWeb.Pagination do
  import Ecto.Query
  alias Homework.Repo

  # TODO: Split this macro module into separate modules for easier use

  defmacro paginated_field(plural_atom, do: block) do
    plural_string = Atom.to_string(plural_atom)
    name_string = "paginated_#{plural_string}"
    name_atom = String.to_atom(name_string)
    quote do
      field(unquote(plural_atom), unquote(name_atom)) do
        # TODO: Turn this into a custom scalar type
        #arg(:page_info, :page_info)
        arg(:limit, :integer)
        arg(:skip, :integer)
        unquote(block)
      end
    end
  end

  defmacro paginated_object(singular_atom, plural_atom, do: block) do
    plural_string = Atom.to_string(plural_atom)
    name_string = "paginated_#{plural_string}"
    name_atom = String.to_atom(name_string)
    quote do
      object unquote(name_atom) do
        field :results, list_of(unquote(singular_atom))
        field :meta, :page_info
      end

      object unquote(singular_atom) do
        unquote(block)
      end
    end
  end


  def paginated_resolver_results(module, results, args) do
    total_rows = Repo.aggregate(from(m in module), :count, :id)
    {:ok, %{
      results: results,
      meta: %{
        total_rows: total_rows,
        limit: Map.get(args, :limit, nil),
        skip: Map.get(args, :skip, nil)
      }
    }}
  end

  def paginated_query(query, %{skip: skip, limit: limit}) do
    query
    |> offset(^skip)
    |> limit(^limit)
  end

  def paginated_query(query, %{skip: skip}) do
    query
    |> offset(^skip)
  end

  def paginated_query(query, %{limit: limit}) do
    query
    |> limit(^limit)
  end

  def paginated_query(query, _args), do: query

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: :macros
      object :page_info do
        field :limit, :integer
        field :skip, :integer
        field :total_rows, :integer
      end
    end
  end
end
