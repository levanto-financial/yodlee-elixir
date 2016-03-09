defmodule Yodlee.Provider do

  def search(creds, name, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "get", "#{cobrand_name}/v1/providers", %{"name" => name})
  end

  def search!(creds, name, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      search(creds, name, cobrand_name)
    end
  end

  def get(creds, provider_id, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds, "get", "#{cobrand_name}/v1/providers/#{provider_id}")
  end

  def get!(creds, provider_id, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      get(creds, provider_id, cobrand_name)
    end
  end

  def create_account(creds, provider_id, params, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.make_authenticated_request(creds,
      "post", "#{cobrand_name}/v1/providers/#{provider_id}", params, [], [], :json)
  end

  def create_account!(creds, provider_id, params, cobrand_name \\ Yodlee.default_cobrand_name) do
    Yodlee.throw_on_fail fn ->
      create_account(creds, provider_id, params, cobrand_name)
    end
  end
end
