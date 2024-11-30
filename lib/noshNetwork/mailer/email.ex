defmodule NoshNetwork.Email do
  @moduledoc false

  import Swoosh.Email
  import NoshNetwork.Mailer, only: [base_email: 0, premail: 1, render_body: 3]

  #  Web.Email.send_and_deliver_email(email, subject, template, args)
  def send_and_deliver_email(email, subject, template, args \\ %{}) do
    Task.async(fn ->
      send_email(email, subject, template, args)
    end)
  end

  def send_email(email, subject, template, args) do
    case Map.get(args, :attachment) do
      nil ->
        try do
          base_email()
          |> subject(subject)
          |> from({"FoodiesNetwork", "uwabunkeonyeijeoma@gmail.com"})
          |> to(email)
          |> render_body(template, title: subject, args: args)
          |> premail()
          |> NoshNetwork.Mailer.deliver()
          |> IO.inspect(label: "Mail Deliverd ")
        rescue
          e ->
            IO.inspect(e, label: "Error Sending Email")
        end

      attachment ->
        try do
          base_email()
          |> subject(subject)
          |> from({"FoodiesNetwork", "uwabunkeonyeijeoma@gmail.com"})
          |> to(email)
          |> render_body(template, title: subject, args: args)
          |> attachment(attachment)
          |> premail()
          |> NoshNetwork.Mailer.deliver()
          |> IO.inspect(label: "Mail Deliverd with attachment")
        rescue
          e ->
            IO.inspect(e, label: "Error Sending Email")
        end
    end
  end
end
