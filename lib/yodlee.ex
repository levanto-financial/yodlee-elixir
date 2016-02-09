import Logger

defmodule Yodlee do
  use Application
  use HTTPoison.Base

  @requesthandler Application.get_env(:yodlee, :request_handler)

  def start(_type, _args) do
    start
    Yodlee.Supervisor.start_link
  end

  def process_url(endpoint) do
    "https://rest.developer.yodlee.com/services/srest/restserver/v1.0" <> endpoint
  end

  def req_headers() do
    HashDict.new
      |> Dict.put("Content-Type",  "application/x-www-form-urlencoded")
  end

  def request(method, endpoint, body, headers, options) do
    Logger.info "#{method} #{endpoint}"
    super(method, endpoint, body, headers, options)
  end

  def make_request(method, endpoint, body \\ [], headers \\ [], options \\ []) do
    rb = Yodlee.URI.encode_query(body)
    rh = req_headers
      |> Dict.merge(headers)
      |> Dict.to_list
    case @requesthandler.request(method, endpoint, rb, rh, options) do
      {:ok, response} ->
        {:ok, Poison.decode!(response.body)}
      {:error, response} ->
        {:error, response}
    end
  end
end

Yodlee.start
