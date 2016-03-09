defmodule Yodlee.User do

  def login(creds, user_login, user_password, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "post", "#{cobrand_name}/v1/user/login", %{
      "loginName" => user_login,
      "password" => user_password
    })
  end
  def login!(creds, user_login, user_password, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      login(creds, user_login, user_password, cobrand_name)
    end
  end

  def logout(creds, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "post", "#{cobrand_name}/v1/user/logout")
  end

  def logout!(creds, user_login, user_password, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      logout(creds, cobrand_name)
    end
  end

  # Returns:
  # {
  #   "user": {
  #     "id": 25890176,
  #     "loginName": "levanto-12312a",
  #     "name": {},
  #     "session": {
  #       "userSession": "06102015_0:d8744eff21d68ab60497ae1bbcfd5c7a59a69e75ac4625c8d3b8ccd4639ee6ee5c6a8df0dde8f91c9c03d48fe4b5e748f440bd521741f8958df07599f5b805e5"
  #     },
  #     "preferences": {
  #       "currency": "USD",
  #       "timeZone": "PST",
  #       "dateFormat": "MM/dd/yyyy"
  #     }
  #   }
  # }
  def create(creds, params, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "post", "#{cobrand_name}/v1/user/register", %{
      "registerParam" => Poison.encode!(params)
    })
  end
  def create!(creds, params, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      create(creds, params, cobrand_name)
    end
  end

  def delete(creds, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "delete", "#{cobrand_name}/v1/user/unregister")
  end

  def delete!(creds, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      delete(creds, cobrand_name)
    end
  end

  def info(creds, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "get", "#{cobrand_name}/v1/user")
  end

  def info!(creds, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      info(creds, cobrand_name)
    end
  end

end
