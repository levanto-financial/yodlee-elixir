defmodule Yodlee.UserCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      def rand_str(length) do
        :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
      end
    end
  end

  def rand_str(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  setup_all do
    user_params = %{
          "loginName" => rand_str(8),
          "password" => "aho12eoed12d$$Aa",
          "email" => "test-#{rand_str(6)}@levantofinancial.com"}

    {cob_tok, new_user} = Yodlee.as_cob!(
      System.get_env("COBRAND_USERNAME"),
      System.get_env("COBRAND_PASSWORD"), fn cob_tok ->
      {cob_tok, Yodlee.User.create!(cob_tok, %{
        "user" => user_params})}
    end)
    user_tok = new_user["user"]["session"]["userSession"]
    creds = {cob_tok, user_tok}

    on_exit fn ->
      Yodlee.User.delete creds
    end
    {:ok, [creds: creds, user: new_user[:user], user_params: user_params]}
  end
end
