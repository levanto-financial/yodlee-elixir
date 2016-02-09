defmodule Yodlee.Test.Mock do
  def request(_, _, _, _, _) do
    {:ok, %{body: Poison.encode! %{status: "success"} } }
  end
end
