defmodule Yodlee.ProviderTest do
  use Yodlee.UserCase

  doctest Yodlee.Provider


  def finish_refresh(creds, provider_acct_id) do
    refresh_result = Yodlee.Refresh.get_pending_account_status! creds, provider_acct_id
    case refresh_result["refreshInfo"]["statusCode"] do
      801 ->
        :timer.sleep(2000)
        finish_refresh(creds, provider_acct_id)
      0 ->
        assert refresh_result["refreshInfo"]["statusCode"] == 0
        assert refresh_result["refreshInfo"]["refreshStatus"] == "LOGIN_SUCCESS"
        refresh_result
    end
  end

  test "Provider search", c do
    creds = c[:creds]
    results = Yodlee.Provider.search! creds, "PNC"
    assert results["provider"]
  end

  test "Provider search by params", c do
    creds = c[:creds]
    results = Yodlee.Provider.search! creds, "PNC"
    assert results["provider"]
  end

  test "get provider form info", c do
    creds = c[:creds]
    provider_info = Yodlee.Provider.get! creds, 16441
    assert hd(provider_info["provider"])["id"] == 16441
  end

  test "create user account for provider, get information about it, and delete it", c do
    creds = c[:creds]
    form_params = %{"provider": [%{
      "id": 16441,
      "name": "Dag Site",
      "loginUrl": "http://192.168.210.152:9090/dag/index.do",
      "baseUrl": "http://www.bakerboyer.com/index.cfm?id=105",
      "status": "Supported",
      "oAuthSite": false,
      "lastModified": "2015-06-17T16:46:32Z",
      "forgetPasswordUrl": "http://192.168.210.152:9090/dag/index.do",
      "loginForm": %{
        "id": 16103,
        "forgetPasswordURL": "http://192.168.210.152:9090/dag/index.do",
        "formType": "login",
        "row": [
         %{
          "id": 150862,
          "label": "Catalog",
          "form": "0001",
          "fieldRowChoice": "0001",
          "field": [
           %{
            "id": 65499,
            "name": "LOGIN",
            "type": "text",
            "value": "DAPI.site16441.7",
            "isOptional": false,
            "valueEditable": true
           }
          ]
         },
         %{
          "id": 150863,
          "label": "Password",
          "form": "0001",
          "fieldRowChoice": "0002",
          "field": [
           %{
            "id": 65500,
            "name": "PASSWORD",
            "type": "password",
            "value": "site16441.7",
            "isOptional": false,
            "valueEditable": true
           }
          ]
         }
        ]
      }
     }
    ]}

    provider_info = Yodlee.Provider.create_account! creds, 16441, form_params
    assert provider_info["providerAccountId"]
    provider_acct_id = provider_info["providerAccountId"]

    finish_refresh(creds, provider_acct_id)

    acct_info = Yodlee.Account.search! creds, %{"container" => "bank", "providerAccountId" => provider_acct_id}

    assert acct_info
    IO.inspect acct_info

    # {:ok, _} = Yodlee.Account.delete creds, acct_id
  end
end
