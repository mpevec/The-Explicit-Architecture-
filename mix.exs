defmodule Propy.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :propy,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Propy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:data, "~> 0.4.7"},
      {:fe, "~> 0.1"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ecto_sql, "~> 3.7"},
      {:postgrex, ">= 0.0.0"},
      {:jose, "~> 1.11"},
      {:knigge, "~> 1.4"}
    ]
  end
end
