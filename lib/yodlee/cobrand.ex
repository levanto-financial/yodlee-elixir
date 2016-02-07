defmodule Yodlee.Cobrand do
  @endpoint "/authenticate/coblogin"

  def login(username, password) do
    Yodlee.make_request("post", @endpoint, %{cobrandLogin: username, cobrandPassword: password})
  end
end
