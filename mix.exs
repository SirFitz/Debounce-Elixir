defmodule Debounce.MixProject do
  use Mix.Project

  def project do
    [
      app: :debounce_elixir,
      version: "0.1.0",
      elixir: "~> 1.9",
      name: "Debounce",
      description: "Debounce Email Validator API Wrapper.",
      package: package(),
      source_url: "https://github.com/sirfitz/debounce-elixir",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:jason, "~> 1.1"}
    ]
  end

  defp package do
    [
      files: ["lib", "README*", "mix.exs"],
      maintainers: ["Romario Fitzgerald"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sirfitz/debounce-elixir"}
    ]
  end
end
