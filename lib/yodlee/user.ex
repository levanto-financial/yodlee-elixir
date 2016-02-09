defmodule Yodlee.User do
  @endpoint "/jsonsdk/UserRegistration"

  def register3(username, password, email, cobSessionToken) do
    Yodlee.make_request("post", "#{@endpoint}/register3", %{
      cobSessionToken: cobSessionToken,
      userCredentials: %{
        loginName: username,
        password: password,
        objectInstanceType: "com.yodlee.ext.login.PasswordCredentials",
        emailAddress: email
      }
    })
  end
end
