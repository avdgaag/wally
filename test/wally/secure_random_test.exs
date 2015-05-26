defmodule Wally.SecureRandomTest do
  use ExUnit.Case, async: true
  alias Wally.SecureRandom

  test "generates a token of given length" do
    assert SecureRandom.base64
  end

  test "generates random strings" do
    refute SecureRandom.base64 == SecureRandom.base64
  end
end
