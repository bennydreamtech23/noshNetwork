defmodule NoshNetwork.Repo do
  use Ecto.Repo,
    otp_app: :noshNetwork,
    adapter: Ecto.Adapters.Postgres
end
