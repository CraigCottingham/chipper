defmodule Chipper.MixProject do
  use Mix.Project

  def project do
    [
      app: :chipper,
      version: "0.1.0",
      elixir: "~> 1.6",
      escript: escript(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
    ]
  end

  def application do
    [
      extra_applications: [:logger],
    ]
  end

  def escript, do: [main_module: Chipper]

  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
