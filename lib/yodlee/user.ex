defmodule Yodlee.User do
  def login(cob_session_token, user_login, user_password, cobrand_name \\ "restserver") do
    Yodlee.make_authenticated_request(cob_session_token, "post", "#{cobrand_name}/v1/user/login", %{
      "loginName" => user_login,
      "password" => user_password
    })
  end
  def login!(cob_session_token, user_login, user_password, cobrand_name \\ "restserver") do
    {:ok, res} = login(cob_session_token, user_login, user_password, cobrand_name)
    res
  end
end
