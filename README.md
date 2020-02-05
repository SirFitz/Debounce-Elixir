# Debounce


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `debounce_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:debounce_elixir, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/debounce-elixir](https://hexdocs.pm/debounce-elixir).

## Use

Your configuration will need to know your api key, and any other options eg. photo.

```elixir
# config/config.exs
config :debounce_elixir,
  api: "5e3a00181ca94",
  photo: true
```

Verify an email address

```elixir
Debounce.verify("info@example.com")
{:ok, "unknown", "info@example.com"}
```
