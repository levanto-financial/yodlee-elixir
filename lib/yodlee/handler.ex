defmodule Yodlee.Handler do
  use HTTPoison.Base
  require Logger

  @base Application.get_env(:yodlee, :api_base_url) || "https://developer.api.yodlee.com/ysl/"

  def start(_type, _args) do
    start
  end

  def req_headers(mode \\ :form) do
    content_type = case mode do
      :form -> "application/x-www-form-urlencoded"
      :json -> "application/json"
    end

    HashDict.new
      |> Dict.put("Content-Type",  content_type)
  end

  def request(method, endpoint, body, headers, options) do
    Logger.debug fn -> "#{String.upcase method}\t#{endpoint}" end
    super(method, endpoint, body, headers, options)
  end

  def process_url(endpoint) do
    @base <> endpoint
  end

  def make_request(method, endpoint, body \\ [], headers \\ [], options \\ [], request_mode \\ :form) do
    rb = case request_mode do
      :form -> Yodlee.URI.encode_query(body)
      :json -> Poison.encode!(body)
    end

    rh = req_headers(request_mode)
      |> Dict.merge(headers)
      |> Dict.to_list

    case request(method, endpoint, rb, rh, List.flatten(options, [timeout: 20000])) do
      {:ok, response} ->
        response_body = case response.body do
          "" -> %{}
          nil -> %{}
          x -> Poison.decode!(x)
        end

        cond do
          response.status_code >= 400 ->
            x = response_body |> Map.put("status_code", response.status_code)
            {:error, x}
          true -> {:ok, response_body}
        end
      {:error, response} -> {:error, response}
    end
  end
end
