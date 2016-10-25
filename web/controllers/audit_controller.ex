defmodule Gide.AuditController do
  use Gide.Web, :controller

  alias Gide.Audit

  def index(conn, %{"fk_guid" => fk_guid}) do
    audits = Repo.all(
      from a in Audit,
       where: a.fk_guid == ^fk_guid,
       select: a
      )
    render(conn, "index.json", audits: audits)
  end

  def index(conn, _params) do
    audits = Repo.all(Audit)
    render(conn, "index.json", audits: audits)
  end

  def show(conn, %{"id" => id}) do
    audit = Repo.get!(Audit, id)
    render(conn, "show.json", audit: audit)
  end
end
