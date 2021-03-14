defmodule Quark.Mixfile do
  use Mix.Project

  def project do
    [
      app:  :quark,
      name: "Quark",

      description: "Common combinators for Elixir",
      version: "2.3.1",
      elixir:  "~> 1.11",

      package: [
        maintainers: ["Brooklyn Zelenka"],
        licenses:    ["MIT"],
        links:       %{"GitHub" => "https://github.com/expede/quark"}
      ],

      source_url:   "https://github.com/expede/quark",
      homepage_url: "https://github.com/expede/quark",

      aliases: [
        quality: [
          "test",
          "credo --strict"
        ]
      ],

      deps: [
        {:credo,    "~> 1.5",  only: [:dev, :test], runtime: false},

        {:dialyxir, "~> 1.1",  only: :dev, runtime: false},
        {:earmark,  "~> 1.4",  only: :dev, runtime: false},
        {:ex_doc,   "~> 0.23", only: :dev, runtime: false},

        {:inch_ex,  "~> 2.0",  only: [:dev, :docs, :test], runtime: false}
      ],

      docs: [
        extras: ["README.md"],
        logo: "./brand/logo.png",
        main: "readme"
      ]
    ]
  end
end
