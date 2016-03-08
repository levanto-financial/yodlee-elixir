defmodule Yodlee.MockHandler do

  def start do
    Agent.start_link(fn -> HashDict.new end, name: __MODULE__)
  end


  def add_mock_response(method, endpoint, handler) do
    Agent.get_and_update __MODULE__, fn set ->
      case HashDict.has_key?(set, method) do
        true ->
          set = HashDict.put(set, method, HashDict.put(HashDict.get(set, method), endpoint, handler))
          {set, set}
        false ->
          d = HashDict.new
          d =HashDict.put d, endpoint, handler
          set = HashDict.put(set, method, d)
          {set, set}
      end
    end
  end

  def clear_mock_responses() do
    Agent.get_and_update __MODULE__, fn _ ->
      d = HashDict.new
      {d, d}
    end
  end

  def make_request(method, endpoint, body \\ [], _headers \\ [], _options \\ []) do
    Agent.get __MODULE__, fn set ->
      method_ops = HashDict.fetch!(set, method)
      handler = HashDict.fetch!(method_ops, endpoint)
      handler.(body)
    end
  end

end
