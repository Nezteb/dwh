defmodule HomeworkWeb.RootController do
  use HomeworkWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/graphiql")
  end
end
