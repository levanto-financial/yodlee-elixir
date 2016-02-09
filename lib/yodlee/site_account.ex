defmodule Yodlee.SiteAccount do
  @endpoint "/jsonsdk/SiteAccountManagement"

  def add(cobSessionToken, userSessionToken, site_id) do
    Yodlee.make_request("post", "#{@endpoint}/addSiteAccount1", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken,
      siteId: site_id
    })
  end

  def get_form(cobSessionToken, site_id) do
    Yodlee.make_request("post", "#{@endpoint}/getSiteLoginForm", %{
      cobSessionToken: cobSessionToken,
      siteId: site_id
    })
  end
end
