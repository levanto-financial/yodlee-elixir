defmodule Yodlee.Site do
  @endpoint "/jsonsdk/Refresh"

  def get_info(cobSessionToken, userSessionToken, site_account_id) do
    Yodlee.make_request("post", "#{@endpoint}/getSiteRefreshInfo", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken,
      memSiteAccId: site_account_id
    })
  end
end
