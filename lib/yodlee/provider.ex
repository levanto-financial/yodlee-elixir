defmodule Yodlee.Provider do

  def search(cob_session_token, name, cobrand_name \\ Yodlee.default_cobrand_name) do
    body = %{"name" => name}
    Yodlee.make_authenticated_request(cob_session_token, "get", "#{cobrand_name}/v1/providers", body)
  end

  defp search_by_params(cob_session_token, %{"skip" => skip, "top" => top}, cobrand_name \\ Yodlee.default_cobrand_name) do
    body =  %{"skip" => skip || 0, "top" => top || 500}
    Yodlee.make_authenticated_request(cob_session_token, "get", "#{cobrand_name}/v1/providers", body)
  end

end
