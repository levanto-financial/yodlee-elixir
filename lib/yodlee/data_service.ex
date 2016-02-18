defmodule Yodlee.DataService do
  @endpoint "/jsonsdk/DataService"

  def get_item_summary(cobSessionToken, userSessionToken, site_account_id) do
    Yodlee.make_request("post", "#{@endpoint}/getItemSummaryForItem1", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken,
      memSiteAccId: site_account_id
    })
  end

  def get_infos(cobSessionToken, userSessionToken, site_account_ids) do
    Yodlee.make_request("post", "#{@endpoint}/getRefreshInfo1", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken,
      itemIds: site_account_ids
    })
  end

  def is_refreshing(cobSessionToken, userSessionToken, site_account_id) do
    Yodlee.make_request("post", "#{@endpoint}/isItemRefreshing", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken,
      memSiteAccId: site_account_id
    })
  end
end
