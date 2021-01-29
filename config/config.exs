use Mix.Config

config :whereami, cowboy_port: String.to_integer(System.get_env("PORT") || "4000")
