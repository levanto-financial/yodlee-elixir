defmodule Yodlee.Cobrand do
  def login(cobrand_login, cobrand_password, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_request("post", "#{cobrand_name}/v1/cobrand/login", %{
      "cobrandLogin" => cobrand_login,
      "cobrandPassword" => cobrand_password
    })
  end
  def login!(cobrand_login, cobrand_password, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      login(cobrand_login, cobrand_password, cobrand_name)
    end
  end

  def logout(cobrand_token, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(cobrand_token, "post", "#{cobrand_name}/v1/cobrand/logout")
  end

  def logout!(cobrand_token, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      logout(cobrand_token, cobrand_name)
    end
  end

  def public_key(cobrand_token, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(cobrand_token, "get", "#{cobrand_name}/v1/cobrand/publicKey")
  end
end
