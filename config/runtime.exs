# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """
      
  config :homework, Homework.Repo,
    # ssl: true,
    # IMPORTANT: Or it won't find the DB server
    socket_options: [:inet6],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
  
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """
  
  app_name =
    System.get_env("FLY_APP_NAME") ||
      raise "FLY_APP_NAME not available"
      
  host =  "#{app_name}.fly.dev"
      
  config :homework, HomeworkWeb.Endpoint,
    url: [host: host, port: 80],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000"),
    ],
    secret_key_base: secret_key_base
end

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :homework, HomeworkWeb.Endpoint, server: true

#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

if config_env() == :dev do
  database_url = System.get_env("DATABASE_URL")

  if database_url != nil do
    config :homework, Homework.Repo, 
      url: database_url,
      socket_options: [:inet6]
  end
end