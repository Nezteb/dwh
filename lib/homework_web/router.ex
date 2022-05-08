defmodule HomeworkWeb.Router do
  use HomeworkWeb, :router
  # This dialyzer override fixes this obscure error:
  # lib/homework_web/router.ex:1:no_return
  # Function __checks__/0 has no local return.
  @dialyzer {:no_return, __checks__: 0}

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/" do
    pipe_through(:api)
    
    get "/", RootController, :index

    forward("/api", Absinthe.Plug, schema: HomeworkWeb.Schema)

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: HomeworkWeb.Schema,
      interface: :playground,
      context: %{pubsub: HomeworkWeb.Endpoint}
    )
  end
end
