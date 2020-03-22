defmodule Debounce do
  @base_url "https://api.debounce.io/v1/"
  @moduledoc """
  Documentation for Debounce.
  """

  @doc """
  Debounce verify/1 accepts and email_address and returns a three member tuple containing the summarized results of the check.
  ## Examples

       iex> Debounce.verify("googolplex@yahoo.com")
       {:ok,
        %{
          "photo" => "https://cdn.debounce.io/j3qPRRUBgdrRz9TyNyyZh2ilfAB-EztFQY_Y0g5w_hTb2BvmWOGlroUuj9czIq-Xi51D_Z_RqtUlxCw76Rz4bYYdAPqziTsytZKiV6_gRWQ0y5Rlqstp0r6V3m_hJTYx6WHpKMnceGbIakF71mC505A1ROdZTNgEvLR85rTy--Fvllc1f3QGl0VfLBThqAqixILrBqKZAZNGD5xporjVLg==",
          "status" => "safe",
          "suggestion" => ""
        }, "googleplex@yahoo.com"}

       iex> Debounce.statuses
        ["safe", "bounce", "trap", "temp", "catch_all", "unknown", "invalid_check", "failed_check"]

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

       iex> Debounce.verify("googolplex@yahoo.com")
       {:ok,
        %{
          "photo" => "https://cdn.debounce.io/j3qPRRUBgdrRz9TyNyyZh2ilfAB-EztFQY_Y0g5w_hTb2BvmWOGlroUuj9czIq-Xi51D_Z_RqtUlxCw76Rz4bYYdAPqziTsytZKiV6_gRWQ0y5Rlqstp0r6V3m_hJTYx6WHpKMnceGbIakF71mC505A1ROdZTNgEvLR85rTy--Fvllc1f3QGl0VfLBThqAqixILrBqKZAZNGD5xporjVLg==",
          "status" => "safe",
          "suggestion" => ""
        }, "googleplex@yahoo.com"}

  """
  def verify(email_address, response_type) when is_bitstring(email_address) do
    query_map =
      :debounce_elixir
      |> Application.get_all_env()
      |> Enum.into(%{})
      |> Map.put(:email, email_address)

    query = URI.encode_query(query_map)

    url = @base_url <> "?" <> query

    Application.ensure_all_started(:inets)
    case :httpc.request(:get, {String.to_charlist(url), []}, [], [body_format: :json]) do
      {:ok, {{_, 200, 'OK'}, _headers, body}} ->
        case Jason.decode(body) do
          {:ok, json} ->
             cond do
               response_type == :minimal ->
                 {:ok, resolve_minimal(json), email_address}
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

  def statuses, do: ["safe", "bounce", "trap", "invalid", "temp", "catch_all", "unknown", "invalid_check", "failed_check"]
  defp resolve_minimal(json) do
    new_json = Map.new
     |> Map.put("status", resolve_code(json["debounce"]["code"]))
     |> Map.put("suggestion", json["debounce"]["did_you_mean"])

    new_json = if json["photo"] && json["photo"] != "" do
                  Map.put(new_json, "photo", json["debounce"]["photo"])
               else
                  new_json
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
