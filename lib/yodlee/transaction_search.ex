defmodule Yodlee.TransactionSearch do

  @endpoint "/jsonsdk/TransactionSearchService"

  def search(cobSessionToken, userSessionToken, options) do
    Yodlee.make_request("post", "#{@endpoint}/executeUserSearchRequest", Map.merge(%{
      cobSessionToken: cobSessionToken,
      userSessionToken: userSessionToken
    }, options))
  end

end
