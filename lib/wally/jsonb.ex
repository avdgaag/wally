defmodule Wally.Jsonb do

  defmodule Type do
    @behaviour Ecto.Type

    def type, do: :jsonb

    def cast(any), do: any
    def load(value), do: {:ok, value}
    def dump(value), do: {:ok, value}
  end

  defmodule Extension do
    alias Postgrex.TypeInfo

    @behaviour Postgrex.Extension

    def init(_parameters, opts),
      do: Keyword.fetch!(opts, :library)

    def matching(_library),
      do: [type: "json", type: "jsonb"]

    def format(_library),
      do: :binary

    def encode(%TypeInfo{type: "json"}, map, _state, library),
      do: library.encode!(map)
    def encode(%TypeInfo{type: "jsonb"}, map, _state, library),
      do: <<1, library.encode!(map)::binary>>

    def decode(%TypeInfo{type: "json"}, json, _state, library),
      do: library.decode!(json)
    def decode(%TypeInfo{type: "jsonb"}, <<1, json::binary>>, _state, library),
      do: library.decode!(json)
  end
end
