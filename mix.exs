defmodule Quark.Mixfile do
  use Mix.Project

  def project do
    [app:     :quark,
     name:    "Quark",

     description: "Common combinators for Elixir",
     package: package,

     version: "1.0.0",
     elixir:  "~> 1.1",

     source_url:   "https://github.com/robot-overlord/quark",
     homepage_url: "https://github.com/robot-overlord/quark",

     build_embedded:  Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     deps: deps,
     docs: [
       logo: "./logo.png",
       extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.10", only: :dev}]
  end

  defp package do
    [maintainers: ["Brooklyn Zelenka"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/robot-overlord/quark",
              "Docs" => "http://robot-overlord.github.io/quark/"}]
  end

end
