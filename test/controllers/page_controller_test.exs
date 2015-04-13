defmodule Wally.PageControllerTest do
  use Wally.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert conn.resp_body =~ "Wally"
  end
end
