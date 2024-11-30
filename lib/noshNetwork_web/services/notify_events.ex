defmodule NoshNetworkWeb.Services.NotifyEvents do
  @moduledoc """
   This module sends notification alerts to users subscribed to the notification_live channel.
  """
  alias Phoenix.PubSub
  alias NoshNetwork.Data.Context.Users
  alias NoshNetworkWeb.Services.Cache
  alias NoshNetwork.Email

  @doc """
  Sends a push/email/sms or custom type of notification alert to the specified user.

  ## Params
  - user_id` - unique identifier for the user.
  - params` - A map containing notification parameters.

  ## List of acceptable params
  - :kind - The kind of the notification, could be one of :info | :error | :success
  - :title - The title for the push alert.
  - :text - The text of the push notification.
  - :subject - The subject for the email.
  - :template - The email template filename.
  - :email_args - Arguments for the email body.
  - :sms_text - The text to be sent in the SMS.
  - :to - The redirect link when the user clicks the push notification.
  - :event - The event type, accepted events are :push | :email | :sms | :push_email | :all
  - :delay - delay in milliseconds in case need to schedule the push

  Required parameters for :push type event:
  - :kind, :title, :text, :event (:push)

  Required parameters for :email type event:
  - :subject, :template, :email_args, :event (:email)

  Required parameters for :sms type event:
  - :sms_text, :event (:sms)

  Optional parameters:
  - :to - The redirect link when the user clicks the push notification.

  ## Example usage

  # push event
    - put_user_alert(user_id, %{kind: :info, title: "Title", text: "Notification text", event: :push, to: "/link"})
  # email event
    - put_user_alert(user_id, %{email: "user@example.com", subject: "Email Subject", template: "email_template", email_args: [arg1: "value"], event: :email})
  # sms event
    - put_user_alert(user_id, %{sms_text: "SMS Text", event: :sms})
  # all event
    - put_user_alert(user_id, %{
        kind: :info,
        title: "Title",
        text: "Notification text",
        event: :all,
        to: "/link",
        subject: "Email Subject",
        template: "email_template",
        email_args: [arg1: "value"],
        sms_text: "SMS Text"
      })
  """
  def put_user_alert(user_id, %{event: :push} = params) do
    push_alert(user_id, params)
  end

  def put_user_alert(user_id, %{event: :email} = params) do
    email_alert(user_id, params)
  end

  # def put_user_alert(user_id, %{event: :sms} = params) do
  #   sms_alert(user_id, params)
  # end

  def put_user_alert(user_id, %{event: :email_push} = params) do
    send_email_and_push_alerts(user_id, params)
  end

  def put_user_alert(user_id, %{event: :all} = params) do
    send_all_alerts(user_id, params)
  end

  @doc false
  defp push_alert(user_id, params) do
    Cache.put_user_notification(user_id, params)
    broadcast(user_id, {:user_alert, params})
  end

  @doc false
  defp email_alert(user_id, %{subject: subject, template: template, email_args: args}) do
    user_id
    |> user_email()
    |> send_email(subject, template, args)
  end

  @doc false
  # defp sms_alert(user_id, %{sms_text: text}) do
  #   user_id
  #   |> user_phone_number()
  #   |> send_sms(text)
  # end

  defp send_email_and_push_alerts(user_id, params) do
    email_alert(user_id, params)
    push_alert(user_id, params)
  end

  @doc false
  defp send_all_alerts(user_id, params) do
    push_alert(user_id, params)
    email_alert(user_id, params)
  end

  # sms_alert(user_id, params)

  @doc false
  # defp send_sms(phone_number, text) do
  #   UserManagement.send_sms_for_user_alert(phone_number, text)
  # end

  defp send_email(email, subject, template, args) do
    Email.send_email(email, subject, template, args)
  end

  @doc false
  defp broadcast(user_id, payload) do
    IO.inspect(payload, label: "Payload")
    PubSub.broadcast(NoshNetwork.PubSub, user_topic(user_id), payload)
  end

  @doc false
  defp user_topic(user_id) when is_binary(user_id), do: "alerts:#{user_id}"

  @doc false
  defp user_email(user_id), do: Users.get_user!(user_id).email
end
