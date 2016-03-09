defmodule Yodlee.Account do

  def delete(creds, account_id, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "delete", "#{cobrand_name}/v1/accounts/#{account_id}")
  end

  def delete!(creds, account_id, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      delete(creds, account_id, cobrand_name)
    end
  end

  def get(creds, account_id, container_name, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "get", "#{cobrand_name}/v1/accounts/#{account_id}", %{
      "container" => container_name
    })
  end

  def get!(creds, account_id, container_name, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      get(creds, account_id, container_name, cobrand_name)
    end
  end

  def search(creds, params, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "get", "#{cobrand_name}/v1/accounts", params)
  end

  def search!(creds, params, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      search(creds, params, cobrand_name)
    end
  end

end
