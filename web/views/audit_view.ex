defmodule Gide.AuditView do
  use Gide.Web, :view

  def render("index.json", %{audits: audits}) do
    %{data: render_many(audits, Gide.AuditView, "audit.json")}
  end

  def render("show.json", %{audit: audit}) do
    %{data: render_one(audit, Gide.AuditView, "audit.json")}
  end

  def render("audit.json", %{audit: audit}) do
    %{id: audit.id,
      fk_guid: audit.fk_guid,
      event: audit.event,
      ip: audit.ip}
  end
end
