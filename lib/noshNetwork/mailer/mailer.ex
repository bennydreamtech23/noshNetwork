defmodule NoshNetwork.Mailer do
  use Swoosh.Mailer, otp_app: :noshNetwork
  import Swoosh.Email, only: [new: 0, from: 2, html_body: 2]

  def base_email do
    new()
    |> from(from_email())
  end

  def render_body(email, template), do: render_body(email, template, %{})

  def render_body(email, template, args) when is_atom(template) and is_map(args) do
    heex = apply(NoshNetworkWeb.EmailHTML, template, [args])
    html_with_layout = render_component(NoshNetworkWeb.EmailHTML.layout(%{inner_content: heex}))

    html_body(
      email,
      html_with_layout
    )
  end

  def render_body(email, "" <> template, args) do
    template = template |> String.split(".") |> List.first() |> String.to_atom()
    render_body(email, template, args)
  end

  def render_body(email, template, args) when is_list(args) do
    render_body(email, template, Map.new(args))
  end

  # Inline CSS so it works in all browsers
  def premail(email) do
    html = Premailex.to_inline_css(email.html_body)

    email
    |> html_body(html)
  end

  defp render_component(heex) do
    heex |> Phoenix.HTML.Safe.to_iodata() |> IO.chardata_to_string()
  end

  defp from_email, do: "uwabunkeonyeijeoma@gmail.com"
end
