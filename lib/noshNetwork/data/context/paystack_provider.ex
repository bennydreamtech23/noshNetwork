defmodule NoshNetwork.Data.Context.PaystackProvider do
  @base_url "https://api.paystack.co/transaction/initialize"
  @test_secret_key "sk_test_38bfad036e3e593234dc207fd109ff8461b70816"
  @timeout 50_000

  # Initializes the Paystack payment process
  def initialize_paystack(user, amount) do
    request_body = initialize_paystack_body(user, amount) |> Jason.encode!()

    case invoke_paystack_api(request_body) do
      {:ok, account_detail} ->
        IO.inspect(account_detail, label: "Account Detail")
        {:ok, account_detail}

      {:error, error} ->
        IO.inspect(error, label: "Error")
        {:error, :request_not_successful}
    end
  end

  defp initialize_paystack_body(user, amount) do
    %{
      "email" => user.email,
      "amount" => Integer.to_string(amount * 100),
      "callback_url" => "http://localhost:4000/users/booking"
    }
  end

  defp invoke_paystack_api(req_body) do
    headers = request_headers()

    case HTTPoison.post(@base_url, req_body, headers, timeout: @timeout, recv_timeout: @timeout) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        with {:ok, response_body} <- Jason.decode(body),
             %{"status" => true, "data" => data} <- response_body do
          {:ok, data}
        else
          {:ok, response_body} ->
            IO.inspect(response_body, label: "Response Body with Error")
            {:error, response_body}

          {:error, decode_error} ->
            IO.inspect(decode_error, label: "Decode Error")
            {:error, :invalid_response}
        end

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, %{status_code: status_code, body: Jason.decode!(body)}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason, label: "HTTPoison Error")
        {:error, reason}
    end
  end

  defp request_headers() do
    [
      {"Authorization", "Bearer " <> @test_secret_key},
      {"Content-Type", "application/json"}
    ]
  end
end
