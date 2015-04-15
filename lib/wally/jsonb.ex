defmodule Wally.Jsonb do
  @moduledoc """
  Adds capabilities to Ecto models to deal with JSONB columns from a PostgreSQL
  database.
  """

  defmodule Type do
    @behaviour Ecto.Type

    @moduledoc """
    Implements JSONB as an Ecto type to be used in models and schema definitions.
    """

    def type, do: :jsonb

    def cast(any), do: any
    def load(value), do: {:ok, value}
    def dump(value), do: {:ok, value}
  end

  defmodule Extension do
    alias Postgrex.TypeInfo

    @moduledoc """
    Adds support for JSONB columns to the postgrex driver, as per the official
    postgrex README.
    """

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
