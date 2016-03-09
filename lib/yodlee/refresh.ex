defmodule Yodlee.Refresh do

  def begin(creds, account_ids, cobrand_name \\ Yodlee.default_cobrand_name) do
    ids_param = cond do
      is_list(account_ids) -> Enum.join(account_ids, ",")
      true -> Enum.join([account_ids], ",")
    end
    Yodlee.make_authenticated_request(creds, "post", "#{cobrand_name}/v1/refresh", %{
      "accountIds" => ids_param
    })
  end

  def begin!(creds, account_ids, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      begin(creds, account_ids, cobrand_name)
    end
  end

  def get_pending_account_status(creds, provider_account_id, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "get", "#{cobrand_name}/v1/refresh/#{provider_account_id}")
  end

  def get_pending_account_status!(creds, provider_account_id, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      get_pending_account_status(creds, provider_account_id, cobrand_name)
    end
  end

end
