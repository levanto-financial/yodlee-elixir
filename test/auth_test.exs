defmodule YodleeAuthTest do
  use ExUnit.Case, async: false

  doctest Yodlee.Auth

  test "successful cobrand login" do
    Yodlee.MockHandler.add_mock_response "post", "/authenticate/coblogin", fn _ ->
      {:ok, %{
        "cobrandConversationCredentials": %{
          "sessionToken": "abcd1234"
        }
      }}
    end

    {:ok, response } = Yodlee.Auth.coblogin("test-cobrand-username", "test-cobrand-password")
    assert response.cobrandConversationCredentials
    assert response.cobrandConversationCredentials.sessionToken
    Yodlee.MockHandler.clear_mock_responses
  end

  test "Failed cobrand login" do
    Yodlee.MockHandler.add_mock_response "post", "/authenticate/coblogin", fn _ ->
      {:error, %{
        "Error": [%{
          "errorDetail": "Invalid Cobrand Credentials"
        }]
      }}
    end

    {:error, errors } = Yodlee.Auth.coblogin("test-cobrand-username", "test-cobrand-password")

    assert hd(errors).errorDetail == "Invalid Cobrand Credentials"
    Yodlee.MockHandler.clear_mock_responses

  end
end
