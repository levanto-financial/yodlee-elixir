defmodule YodleeAuthTest do
  use ExUnit.Case, async: false

  doctest Yodlee.Cobrand

  test "successful cobrand login" do
    Yodlee.MockHandler.add_mock_response "post", "restserver/v1/cobrand/login", fn _ ->
      {:ok, %{
        "applicationId" => "3A4CAE9B71A1CCD7FF41F51006E9ED00",
        "cobrandId" => 1111,
        "session" => %{
          "cobSession" => "0806201"
          }
        }
      }
    end

    {:ok, response } = Yodlee.Cobrand.login("test-cobrand-username", "test-cobrand-password")
    assert response["session"]
    assert response["session"]["cobSession"]
    Yodlee.MockHandler.clear_mock_responses
  end

  # test "Failed cobrand login" do
  #   Yodlee.MockHandler.add_mock_response "post", "restserver/v1/cobrand/login", fn _ ->
  #     {:error, %{
  #       "Error": [%{
  #         "errorDetail": "Invalid Cobrand Credentials"
  #       }]
  #     }}
  #   end

  #   {:error, errors } = Yodlee.Auth.coblogin("test-cobrand-username", "test-cobrand-password")

  #   assert hd(errors).errorDetail == "Invalid Cobrand Credentials"
  #   Yodlee.MockHandler.clear_mock_responses

  # end

  # test "successful user login" do
  #   Yodlee.MockHandler.add_mock_response "post", "/authenticate/login", fn _ ->
  #     {:ok, %{
  #       "userContext": %{
  #         "conversationCredentials": %{
  #           "sessionToken": "abcd1234"
  #         }
  #       }
  #     }}
  #   end

  #   {:ok, response } = Yodlee.Auth.login("test-cobrand-token", "user", "password")
  #   assert response.userContext.conversationCredentials.sessionToken
  #   Yodlee.MockHandler.clear_mock_responses
  # end

  # test "Failed user login" do
  #   Yodlee.MockHandler.add_mock_response "post", "/authenticate/login", fn _ ->
  #     {:error, %{
  #       "Error": [%{
  #         "errorDetail": "Invalid User Credentials"
  #       }]
  #     }}
  #   end

  #   {:error, errors } = Yodlee.Auth.login("test-cobrand-token", "user", "password")

  #   assert hd(errors).errorDetail == "Invalid User Credentials"
  #   Yodlee.MockHandler.clear_mock_responses

  # end

end
