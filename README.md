# Debounce


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `debounce_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:debounce_elixir, "~> 0.1.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/debounce_elixir](https://hexdocs.pm/debounce_elixir).

## Use

Your configuration will need to know your api key, and any other options eg. photo.

```elixir
# config/config.exs
config :debounce_elixir,
  api: "<API_KEY>",
  photo: true
```

Verify an email address

```elixir
Debounce.verify("googolplex@yahoo.com")
{:ok,
 %{
   "photo" => "https://cdn.debounce.io/j3qPRRUBgdrRz9TyNyyZh2ilfAB-EztFQY_Y0g5w_hTb2BvmWOGlroUuj9czIq-Xi51D_Z_RqtUlxCw76Rz4bYYdAPqziTsytZKiV6_gRWQ0y5Rlqstp0r6V3m_hJTYx6WHpKMnceGbIakF71mC505A1ROdZTNgEvLR85rTy--Fvllc1f3QGl0VfLBThqAqixILrBqKZAZNGD5xporjVLg==",
   "status" => "safe",
   "suggestion" => ""
 }, "googleplex@yahoo.com"}
```
