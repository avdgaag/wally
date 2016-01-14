defmodule Wally.SecureToken do
  @doc "Generate a new random token suitable for use in URLs."
  def generate(length \\ 32) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
