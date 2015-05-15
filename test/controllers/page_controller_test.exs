defmodule Wally.PageControllerTest do
  use Wally.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Wally"
  end
end
