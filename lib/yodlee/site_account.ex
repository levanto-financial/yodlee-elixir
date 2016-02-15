defmodule Yodlee.SiteAccount do
  @endpoint "/jsonsdk/SiteAccountManagement"

  def all(cobSessionToken, userSessionToken) do
    Yodlee.make_request("post", "#{@endpoint}/getAllSiteAccounts", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken
    })
  end

  def add(cobSessionToken, userSessionToken, site_id, credentialFields) do
    Yodlee.make_request("post", "#{@endpoint}/addSiteAccount1", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken,
      siteId: site_id,
      credentialFields: credentialFields
    })
  end

  def get_form(cobSessionToken, site_id) do
    Yodlee.make_request("post", "#{@endpoint}/getSiteLoginForm", %{
      cobSessionToken: cobSessionToken,
      siteId: site_id
    })
  end
end
