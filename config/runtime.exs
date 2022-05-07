# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

config :homework, HomeworkWeb.Endpoint, server: true
# end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """
  
  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []
      
  config :homework, Homework.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6
  
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """
  
  host =  System.get_env("HOST") || "localhost"
  port = String.to_integer(System.get_env("PORT") || "8080")
      
  config :homework, HomeworkWeb.Endpoint,
    url: [host: host, port: port],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port,
      # transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base
end

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :homework, HomeworkWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
