defmodule Whereami.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Whereami.GeoServer, []},
      {Plug.Cowboy, scheme: cowboy_scheme(), plug: Whereami.Router, options: [port: cowboy_port()]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Whereami.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:whereami, :cowboy_port, 4000)
  defp cowboy_scheme, do: if Mix.env == :prod, do: :https, else: :http
end
