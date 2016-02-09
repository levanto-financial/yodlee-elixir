import Logger

defmodule Yodlee do
  use Application

  @request_handler Application.get_env(:yodlee, :request_handler)

  def start do
    @request_handler.start
    Yodlee.Supervisor.start_link
  end

  def start(_type, _process) do
    start
  end

  def make_request(method, endpoint, body \\ [], headers \\ [], options \\ []) do
    case @request_handler.make_request(method, endpoint, body, headers, options) do
      {:ok, resp} ->
        {:ok, resp}
      {:error, errorResp} ->
        {:error, errorResp[:Error]}
    end
  end
end

Yodlee.start
