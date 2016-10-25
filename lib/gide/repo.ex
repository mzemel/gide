defmodule Gide.Repo do
  if Mix.env == :test do
    use Ecto.Repo, otp_app: :gide, adapter: Sqlite.Ecto
  else
    use Ecto.Repo, otp_app: :gide, adapter: Ecto.Adapters.Postgres
  end
end
