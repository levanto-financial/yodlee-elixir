defmodule EncodeTest do
  use ExUnit.Case

  test "basic key-value pairs" do
    assert Yodlee.URI.encode_query( %{a: "b"}) == "a=b"
    assert Yodlee.URI.encode_query( %{a: "b", c: "D"}) == "a=b&c=D"
    assert Yodlee.URI.encode_query( %{a: "b", c: "D", "e": 6}) == "a=b&c=D&e=6"
  end

  test "simple map of objects" do
    assert Yodlee.URI.encode_query(%{a: %{"b": "c"}}) == "a.b=c"
  end

  test "simple list of objects" do
    assert Yodlee.URI.encode_query(%{a: ["b", "c"]}) == "a[0]=b&a[1]=c"
  end

  test "deeply nested objects" do
    assert Yodlee.URI.encode_query(%{a: %{b: 6, c: 17, d: %{e: 21}}}) == "a.b=6&a.c=17&a.d.e=21"
  end

  test "deeply nested objects with a list" do
    assert Yodlee.URI.encode_query(%{a: %{b: 6, c: [1, 14, 26], d: %{e: 21}}}) == "a.b=6&a.c[0]=1&a.c[1]=14&a.c[2]=26&a.d.e=21"
  end

  test "URI encoding" do
    assert Yodlee.URI.encode_query(%{"Search Term": "Search Thing"}) == "Search%20Term=Search%20Thing"
  end

end
