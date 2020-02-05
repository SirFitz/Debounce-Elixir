defmodule Debounce do
  @base_url "https://api.debounce.io/v1/"
  @moduledoc """
  Documentation for Debounce.
  """

  @doc """
  Debounce verify/1 accepts and email_address and returns a three member tuple containing the summarized results of the check.

  ## Examples

       iex> Debounce.verify("info@example.com")
       {:ok, "unknown", "info@example.com"}

  """
  def verify(email_address), do: verify(email_address, :minimal)
  @doc """
  Debounce verify/2 accepts and email_address and response_type atom (:full or :minimal)  and returns a three member tuple containing the results of the check..

  ## Examples

      iex> Debounce.verify("info@example.com", :full)
      {:ok,
       %{
         "balance" => "3198.6",
         "debounce" => %{
           "code" => "7",
           "did_you_mean" => "",
           "email" => "info@example.com",
           "free_email" => "false",
           "photo" => "",
           "reason" => "Unknown",
           "result" => "Unknown",
           "role" => "true",
           "send_transactional" => "1"
         },
         "success" => "1"
       }, "info@example.com"}

       iex> Debounce.verify("info@example.com", :minimal)
       {:ok, "unknown", "info@example.com"}

  """
  def verify(email_address, response_type) when is_bitstring(email_address) do
    query =
      :debounce_elixir
      |> Application.get_all_env()
      |> Enum.into(%{})
      |> Map.put(:email, email_address)
      |> URI.encode_query

    url = @base_url <> "?" <> query

    Application.ensure_all_started(:inets)
    case :httpc.request(:get, {String.to_charlist(url), []}, [], [body_format: :json]) do
      {:ok, {{_, 200, 'OK'}, _headers, body}} ->
        case Jason.decode(body) do
          {:ok, json} ->
             cond do
               response_type == :minimal ->
                 {:ok, resolve_code(json["debounce"]["code"]), email_address}
               response_type == :full ->
                 {:ok, json, email_address}
               true ->
                 {:ok, json, email_address}
             end
          {:error, reason} ->
              {:error, reason, email_address}
        end
      error ->
        {:error, error, email_address}
    end
  end

  defp resolve_code("1"), do:  "invalid"
  defp resolve_code("2"), do:  "trap"
  defp resolve_code("3"), do:  "temp"
  defp resolve_code("4"), do:  "catch_all"
  defp resolve_code("5"), do:  "safe"
  defp resolve_code("6"), do:  "bounce"
  defp resolve_code("7"), do:  "unknown"
  defp resolve_code("8"), do:  "safe"
  defp resolve_code(_), do:  "invalid_check"

end
