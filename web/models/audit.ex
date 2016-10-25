defmodule Gide.Audit do
  use Gide.Web, :model

  schema "audits" do
    field :fk_guid, Ecto.UUID
    field :event, :string
    field :ip, :string

    timestamps
  end

  @schema_file File.read!("#{File.cwd!}/priv/static/schema/v1.json") |> Poison.decode!

  @required_fields @schema_file 
                   |> Map.fetch!("required")

  @optional_fields @schema_file
                   |> Map.fetch!("properties")
                   |> Dict.keys
                   |> Kernel.--(@required_fields)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
