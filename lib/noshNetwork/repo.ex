defmodule NoshNetwork.Repo do
  use Ecto.Repo,
    otp_app: :noshNetwork,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 5
end
