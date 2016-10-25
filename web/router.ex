defmodule Gide.Router do
  use Gide.Web, :router

  pipeline :browser do
    plug :accepts, ["html, text"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Gide do
    pipe_through :browser # Use the default browser stack

    get "/offset/test", OffsetController, :test
    get "/offset/current", OffsetController, :current

    get "/health/lb", HealthController, :ok, as: :health

  end

  scope "/api", Gide do
    pipe_through :api

    resources "/audits", AuditController, only: [:index, :show]
  end

end
