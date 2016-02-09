defmodule Yodlee.Site do
  @endpoint "/jsonsdk/SiteTraversal"

  def search(cobSessionToken, userSessionToken, siteSearchString) do
    Yodlee.make_request("post", "#{@endpoint}/searchSite", %{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken,
      siteSearchString: siteSearchString
    })
  end
end
