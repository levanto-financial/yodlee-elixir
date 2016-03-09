defmodule Yodlee.Test.Cobrand do
  use ExUnit.Case, async: false

  doctest Yodlee.Cobrand

  test "cobrand login" do
    case Yodlee.Cobrand.login(System.get_env("COBRAND_USERNAME"), System.get_env("COBRAND_PASSWORD")) do
      x ->
        {status, res} = x
        assert status == :ok
        assert res["session"]
        assert res["session"]["cobSession"]
    end
  end

  test "cobrand login!" do
    res = Yodlee.Cobrand.login! System.get_env("COBRAND_USERNAME"), System.get_env("COBRAND_PASSWORD")
    assert res["session"]
    assert res["session"]["cobSession"]
  end

  test "cobrand login w/ bad username" do
    case Yodlee.Cobrand.login("dqwndqw", System.get_env("COBRAND_PASSWORD")) do
      x ->
        {status, res} = x
        assert status == :error
        assert res["status_code"] == 401
        assert res["errorCode"] == "Y002"
    end
  end

  test "cobrand login w/ bad password" do
    case Yodlee.Cobrand.login(System.get_env("COBRAND_USERNAME"), "1d2h812dh12iubjf") do
      x ->
        {status, res} = x
        assert status == :error
        assert res["status_code"] == 401
        assert res["errorCode"] == "Y002"
    end
  end

  test "cobrand login! w/ bad password" do
    assert_raise RuntimeError, fn ->
      Yodlee.Cobrand.login!(System.get_env("COBRAND_USERNAME"), "1d2h812dh12iubjf")
    end
  end

end
