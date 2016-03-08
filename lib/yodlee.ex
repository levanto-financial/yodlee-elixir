defmodule Yodlee do
  use Application
  require Logger

  @request_handler Application.get_env(:yodlee, :request_handler) || Yodlee.Handler
  @default_cobrand_name Application.get_env(:yodlee, :default_cobrand_name) || "restserver"

  def start do
    @request_handler.start
    Yodlee.Supervisor.start_link
  end

  def start(_type, _process) do
    start
  end

  def default_cobrand_name do
    @default_cobrand_name
  end

  def as_cob(cob_username, cob_password, x) do
    %{"session" => %{
      "cobSession" => tok}
    } = case Yodlee.Cobrand.login(cob_username, cob_password) do
      {:ok, resp} -> resp
      err ->
        IO.inspect err
        err
    end
    try do
      case x.(tok) do
        {:ok, res} -> {:ok, res}
        {:error, e} -> {:error, e}
        y -> {:ok, y}
      end
    rescue e ->
      {:error, e}
    end
  end

  def as_cob!(cob_username, cob_password, x) do
    {:ok, res} = as_cob(cob_username, cob_password, x)
    res
  end

  def as_cob_and_user(cob_username, cob_password, username, password, x) do
    %{"session" => %{ "cobSession" => tok}}
      = Yodlee.Cobrand.login! cob_username, cob_password
    %{"user" => %{
      "session" => %{ "userSession" => user_tok }
    }} = Yodlee.User.login! tok, username, password
    try do
      case x.({tok, user_tok}) do
        {:ok, res} -> {:ok, res}
        {:error, e} -> {:error, e}
        y -> {:ok, y}
      end
    rescue e ->
      {:error, e}
    end
  end

  def as_cob_and_user!(cob_username, cob_password, username, password, x) do
    {:ok, res} = as_cob_and_user(cob_username, cob_password, username, password, x)
    res
  end

  def make_request(method, endpoint, body \\ [], headers \\ [], options \\ []) do
    complete_headers = List.flatten(headers, [
      "Content-Type": "application/json",
      "accept": "application/json"
    ])
    case method do
      "get" ->
        complete_endpoint = "#{endpoint}?#{URI.encode_query(body)}"
        case @request_handler.make_request(method, complete_endpoint, %{}, complete_headers, options) do
          {:ok, resp} ->
            {:ok, resp}
          {:error, errorResp} ->
            {:error, errorResp[:Error]}
        end
      _ ->
        case @request_handler.make_request(method, endpoint, body, complete_headers, options) do
          {:ok, resp} ->
            {:ok, resp}
          {:error, errorResp} ->
            {:error, errorResp[:Error]}
        end
    end
  end

  def make_authenticated_request(creds, method, endpoint, body \\ [], headers \\ [], options \\ []) do
    auth_token = case creds do
      {cob, usr} -> "{cobSession=#{cob}, userSession=#{usr}}"
      cob -> "{cobSession=#{cob}}"
    end

    complete_headers = List.flatten(headers, [
      "Authorization": auth_token
    ])
    make_request(method, endpoint, body, complete_headers, options)
  end
end

Yodlee.start
