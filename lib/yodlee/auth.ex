defmodule Yodlee.Auth do
  @endpoint "/authenticate"

  def coblogin(cobLogin, cobPassword) do
    Yodlee.make_request("post", "#{@endpoint}/coblogin", %{cobrandLogin: cobLogin, cobrandPassword: cobPassword})
  end

  def login(cobSessionToken, username, password) do
    Yodlee.make_request("post", "#{@endpoint}/login", %{cobSessionToken: cobSessionToken, login: username, password: password})
  end

  def run_as_cobrand(cobLogin, cobPassword, cb) do
    case coblogin(cobLogin, cobPassword) do
      {:ok, %{"cobrandConversationCredentials" =>  %{"sessionToken" => session_token}}} ->
        try do
          {:ok, cb.(session_token)}
        rescue
          e -> {:error, e}
        end
      {:ok, resp } ->
        {:error, "Unexpected API response from coblogin"}
      {:error, err } ->
        {:error, err }
    end
  end

  def run_as_cobrand_and_user(cobLogin, cobPassword, userLogin, userPassword, cb) do

    r = run_as_cobrand(cobLogin, cobPassword, fn session_token ->
      {:ok, res } = run_as_cobrand_and_user(session_token, userLogin, userPassword, cb)
      res
    end)
    r
  end

  def run_as_cobrand_and_user(cobSessionToken, userLogin, userPassword, cb) do
    case login cobSessionToken, userLogin, userPassword do
      {:ok, %{"userContext" => %{"conversationCredentials" => %{"sessionToken" => user_token }}}} ->
        try do
          {:ok, cb.(cobSessionToken, user_token)}
        rescue
          e -> {:error, e}
        end
      {:error, err} ->
        {:error, err }
    end
  end
end
