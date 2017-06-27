defmodule Quark.Mixfile do
  use Mix.Project

  def project do
    [
      app:  :quark,
      name: "Quark",

      description: "Common combinators for Elixir",
      version: "2.3.0",
      elixir:  "~> 1.4",

      package: [
        maintainers: ["Brooklyn Zelenka"],
        licenses:    ["MIT"],
        links:       %{"GitHub" => "https://github.com/expede/quark"}
      ],

      source_url:   "https://github.com/expede/quark",
      homepage_url: "https://github.com/expede/quark",

      aliases: [
        "quality": [
          "test",
          "credo --strict"
        ]
      ],

      deps: [
        {:credo,    "~> 0.8",  only: [:dev, :test]},

        {:dialyxir, "~> 0.5",  only: :dev},
        {:earmark,  "~> 1.2",  only: :dev},
        {:ex_doc,   "~> 0.16", only: :dev},

        {:inch_ex,  "~> 0.5",  only: [:dev, :docs, :test]}
      ],

      docs: [
        extras: ["README.md"],
        logo: "./brand/logo.png",
        main: "readme"
      ]
    ]
  end
end
