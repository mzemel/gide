defmodule Gide.HealthController do
  use Gide.Web, :controller

  plug :action

  def ok(conn, _params) do
    conn |> send_resp(200, "")
  end

end
