defmodule Gide.AuditControllerTest do
  use Gide.ConnCase

  alias Gide.Audit
  @valid_attrs %{event: "some content", fk_guid: "7488a646-e31f-11e4-aace-600308960662", ip: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, audit_path(conn, :index)
    assert json_response(conn, 200) |> Dict.keys == ~w(data)
  end

  test "shows chosen resource", %{conn: conn} do
    audit = Repo.insert! %Audit{}
    conn = get conn, audit_path(conn, :show, audit)
    assert json_response(conn, 200) |> Dict.keys == ~w(data)
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, audit_path(conn, :show, -1)
    end
  end
end
