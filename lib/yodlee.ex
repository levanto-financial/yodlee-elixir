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

  def throw_on_fail(x) do
    case x.() do
      {:ok, result} -> result
      {:error, err} -> raise "Error! - #{Poison.encode!(err)}"
    end
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
    throw_on_fail fn ->
      as_cob(cob_username, cob_password, x)
    end
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
    throw_on_fail fn ->
      as_cob_and_user(cob_username, cob_password, username, password, x)
    end
  end

  def make_request(method, endpoint, body \\ [], headers \\ [], options \\ [], request_mode \\ :form) do
    case method do
      "get" ->
        complete_endpoint = "#{endpoint}?#{URI.encode_query(body)}"
        @request_handler.make_request(method, complete_endpoint, %{}, headers, options, request_mode)
      _ ->
        @request_handler.make_request(method, endpoint, body, headers, options, request_mode)
    end
  end

  def make_authenticated_request(creds, method, endpoint, body \\ [], headers \\ [], options \\ [], request_mode \\ :form) do
    auth_token = case creds do
      {cob, usr} -> "{cobSession=#{cob}, userSession=#{usr}}"
      cob -> "{cobSession=#{cob}}"
    end
    complete_headers = List.flatten(headers, [
      "Authorization": auth_token
    ])
    make_request(method, endpoint, body, complete_headers, options, request_mode)
  end
end

Yodlee.start
