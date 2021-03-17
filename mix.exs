defmodule Whereami.MixProject do
  use Mix.Project

  def project do
    [
      app: :whereami,
      version: "0.1.0",
      elixir: "~> 1.10",
      config_path: "config/config.exs",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Whereami.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:distillery, "~> 2.0", runtime: false},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.0"},
      {:tesla, "~> 1.4"}
    ]
  end
end
