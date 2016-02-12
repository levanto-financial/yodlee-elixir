defmodule Yodlee.AccountSummary do
  @endpoint "/account/summary"

  def all(cobSessionToken, userSessionToken) do
    Yodlee.make_request("post", "#{@endpoint}/all", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken
    })
  end

end
