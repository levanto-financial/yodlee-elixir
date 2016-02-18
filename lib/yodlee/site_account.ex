defmodule Yodlee.SiteAccount do
  @endpoint "/jsonsdk/SiteAccountManagement"

  def all(cobSessionToken, userSessionToken) do
    Yodlee.make_request("post", "#{@endpoint}/getAllSiteAccounts", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken
    })
  end

  def add(cobSessionToken, userSessionToken, site_id, enclosed_type, credentialFields) do
    Yodlee.make_request("post", "#{@endpoint}/addSiteAccount1", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken,
      'credentialFields.enclosedType': enclosed_type,
      siteId: site_id,
      credentialFields: credentialFields
    })
  end

  def remove(cobSessionToken, userSessionToken, memSiteAccId) do
    Yodlee.make_request("post", "#{@endpoint}/removeSiteAccount", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken,
      memSiteAccId: memSiteAccId
    })
  end

  def remove_all(cobSessionToken, userSessionToken) do
    case all(cobSessionToken, userSessionToken) do
      {:ok, site_accounts} ->
        site_account_ids = Enum.map site_accounts, fn x -> x["siteAccountId"] end
        Enum.each site_account_ids, fn id ->
          remove(cobSessionToken, userSessionToken, id)
        end
        {:ok, []}
      x ->
        x
    end
  end

  def get_form(cobSessionToken, site_id) do
    Yodlee.make_request("post", "#{@endpoint}/getSiteLoginForm", %{
      cobSessionToken: cobSessionToken,
      siteId: site_id
    })
  end

  def get_many(cobSessionToken, userSessionToken, site_account_ids \\ [], options \\ %{}) do
    args = %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken
    }
    if length(site_account_ids) > 0 do
      args = Map.merge(args, %{memSiteAccIds: site_account_ids})
    end
    args = Map.merge(args, options)

    Yodlee.make_request("post", "#{@endpoint}/getSiteAccounts1", args)
  end
end
