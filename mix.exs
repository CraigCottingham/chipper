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
      {:dialyzex, "~> 1.1", only: :dev},
      {:mix_test_watch, "~> 0.6.0", only: :dev},
    ]
  end
end
