defmodule Yodlee.ProviderTest do
  use Yodlee.UserCase

  doctest Yodlee.Provider

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

  test "create user account for provider", c do
    creds = c[:creds]
    form_params = %{"provider" => [%{"baseUrl" => "http://64.14.28.129/dag/index.do",
     "containerNames" => ["creditCard", "insurance", "tax", "reward", "bill",
      "bank", "loan", "investment"],
     "favicon" => "https://moneycenter.ydlstatic.com/fastlink/appscenter/siteImage.fastlink.do?access_type=APPS_CENTER_PRODUCTION&siteId=16441&imageType=FAVICON",
     "forgetPasswordUrl" => "http://64.14.28.129/dag/index.do", "id" => 16441,
     "lastModified" => "2016-03-03T10:16:08Z",
     "loginForm" => %{"forgetPasswordURL" => "http://64.14.28.129/dag/index.do",
       "formType" => "login", "id" => 16103,
       "row" => [%{"field" => [%{"id" => 65499, "isOptional" => false,
             "name" => "LOGIN", "type" => "text", "value" => "MyLogin123",
             "valueEditable" => true}], "fieldRowChoice" => "0001",
          "form" => "0001", "id" => 150862, "label" => "Catalog"},
        %{"field" => [%{"id" => 65500, "isOptional" => false,
             "name" => "PASSWORD", "type" => "password", "value" => "12oy1odbj12B",
             "valueEditable" => true}], "fieldRowChoice" => "0002",
          "form" => "0001", "id" => 150863, "label" => "Password"}]},
     "loginUrl" => "http://64.14.28.129/dag/index.do",
     "logo" => "https://moneycenter.ydlstatic.com/fastlink/appscenter/siteImage.fastlink.do?access_type=APPS_CENTER_PRODUCTION&siteId=16441&imageType=LOGO",
     "name" => "Dag Site", "oAuthSite" => false, "status" => "Supported"}]}

    provider_info = Yodlee.Provider.create_account! creds, 16441, form_params
    assert provider_info["providerAccountId"]
  end
end
