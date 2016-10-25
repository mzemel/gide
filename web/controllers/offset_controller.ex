defmodule Gide.OffsetController do
  use Gide.Web, :controller

  plug :action

  def test(conn, _params) do
    render conn, "test.html"
  end

  def current(conn, _params) do
    offset = Kafka.Offset.get_offset
    render conn, "index.html", offset: offset
  end
end
