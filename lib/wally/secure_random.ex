defmodule Wally.SecureRandom do
  @moduledoc """
  Ruby-like SecureRandom module.

  ## Examples

      iex> SecureRandom.base64
      "xhTcitKZI8YiLGzUNLD+HQ=="

      iex> SecureRandom.urlsafe_base64(4)
      "pLSVJw"

  """

  @default_length 16

  @doc """
  Returns random Base64 encoded string.

  ## Examples

      iex> SecureRandom.base64
      "rm/JfqH8Y+Jd7m5SHTHJoA=="

      iex> SecureRandom.base64(8)
      "2yDtUyQ5Xws="

  """
  def base64(len \\ @default_length) when is_integer(len) do
    random_bytes(len)
    |> :base64.encode_to_string
    |> to_string
  end

  @doc """
  Returns random urlsafe Base64 encoded string.

  ## Examples

      iex> SecureRandom.urlsafe_base64
      "xYQcVfWuq6THMY_ZVmG0mA"

      iex> SecureRandom.urlsafe_base64(8)
      "8cN__l-6wNw"

  """
  def urlsafe_base64(len \\ @default_length) when is_integer(len) do
    base64(len)
    |> String.replace(~r/[\n\=]/, "")
    |> String.replace(~r/\+/, "-")
    |> String.replace(~r/\//, "_")
  end

  @doc """
  Returns random bytes.

  ## Examples

      iex> SecureRandom.random_bytes
      <<202, 104, 227, 197, 25, 7, 132, 73, 92, 186, 242, 13, 170, 115, 135, 7>>

      iex> SecureRandom.random_bytes(8)
      <<231, 123, 252, 174, 156, 112, 15, 29>>

  """
  def random_bytes(len \\ @default_length) when is_integer(len) do
    :crypto.strong_rand_bytes(len)
  end
end
