defmodule Yodlee.UserTest do
  use Yodlee.UserCase

  doctest Yodlee.User

  test "Register and delete a user", c do
    creds = c[:creds]
    {cob_tok, user_tok} = creds

    new_user = Yodlee.User.create!(cob_tok, %{
        "user" => %{
          "loginName" => "lib#{rand_str(4)}est",
          "password" => "aho12eoed12d$$Aa",
        "email" => "test-#{rand_str(4)}@example.com"}})
    user_tok = new_user["user"]["session"]["userSession"]
    assert user_tok

    {:ok, res} = Yodlee.User.info {cob_tok, user_tok}
    assert res

    {:ok, _} = Yodlee.User.delete {cob_tok, user_tok}

    {:error, res2} = Yodlee.User.info {cob_tok, user_tok}
    assert res2["status_code"] == 401

  end

  test "User login", c do
    creds = c[:creds]
    user_params = c[:user_params]
    {:ok, user_info} = Yodlee.User.login creds, user_params["loginName"], user_params["password"]
    assert user_info["user"]["session"]["userSession"]
  end

end
