defmodule Yodlee.Handler do
  use HTTPoison.Base
  require Logger

  @base Application.get_env(:yodlee, :api_base_url) || "https://developer.api.yodlee.com/ysl/"

  def start(_type, _args) do
    start
  end

  def req_headers() do
    HashDict.new
      |> Dict.put("Content-Type",  "application/x-www-form-urlencoded")
  end

  def request(method, endpoint, body, headers, options) do
    Logger.info "#{method} #{@base}#{endpoint}"
    super(method, endpoint, body, headers, options)
  end

  def process_url(endpoint) do
    @base <> endpoint
  end

  def make_request(method, endpoint, body \\ [], headers \\ [], options \\ []) do
    rb = Yodlee.URI.encode_query(body)
    rh = req_headers
      |> Dict.merge(headers)
      |> Dict.to_list

    case request(method, endpoint, rb, rh, List.flatten(options, [timeout: 20000])) do
      {:ok, response} ->
        response_body = case response.body do
          "" -> %{}
          nil -> %{}
          x -> Poison.decode!(x)
        end
        {:ok, response_body}
      {:error, response} ->
        {:error, response}
    end
  end
end
