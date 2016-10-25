defmodule Gide.Repo.Migrations.CreateAudit do
  use Ecto.Migration

  def change do
    create table(:audits) do
      add :fk_guid, :uuid
      add :event, :text
      add :ip, :string

      timestamps
    end

  end
end
