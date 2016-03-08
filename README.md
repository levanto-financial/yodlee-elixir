# Yodlee-Elixir [![Build Status](https://travis-ci.org/levanto-financial/yodlee-elixir.svg?branch=master)](https://travis-ci.org/levanto-financial/yodlee-elixir)


Yodlee YSL API for Elixir 

## Example Use

**1)** Setup your cobrand credentials, and run the main script

```sh
COBRAND_USERNAME=sbCobREPLACE_WITH_COBRAND_USERNAME \
COBRAND_PASSWORD=REPLACE_WITH_COBRAND_PASSWORD \
EXAMPLE_USER_LOGIN=A_TEST_USER_LOGIN \
EXAMPLE_USER_PASSWORD=A_TEST_USER_PASSWORD \
iex -S mix run lib/yodlee.ex 

```

**2)** Play!

You can login as your registered cobrand, and then make other API calls that depend on that token
```ex

case Yodlee.as_cob(
      System.get_env("COBRAND_USERNAME"),
      System.get_env("COBRAND_PASSWORD"),
      fn session_token -> 
        "Your session token is #{session_token}"
      end) do
  {:ok, result} -> IO.puts "Result: #{result}"
  {:error, result} -> IO.inspect result
end

# Result: Your session token is 08qd91........dqwdd

```

You may also login as a user associated with your cobrand, to get the user session token

```ex
r = case Yodlee.as_cob_and_user(
  System.get_env("COBRAND_USERNAME"),
  System.get_env("COBRAND_PASSWORD"),
  System.get_env("EXAMPLE_USER_LOGIN"),
  System.get_env("EXAMPLE_USER_PASSWORD"), fn {cob_tok, user_tok} ->
    "User Token: #{user_tok}"
  end) do
  {:ok, result} -> result
  {:error, err} -> raise err
end

IO.inspect r

# User Token: 080620198a32...12e09

```

And then user that user session token to do something like search for banking institutions

```ex

case Yodlee.as_cob(
  System.get_env("COBRAND_USERNAME"),
  System.get_env("COBRAND_PASSWORD"), fn cob_tok ->
    Yodlee.Provider.search(cob_tok, %{"name" => "Star One"})
  end) do
  {:ok, result} ->
    Enum.each result["provider"], fn p -> 
      IO.puts p["name"]
    end
  {:error, err} -> raise err
end

# Star One FCU
# STAR Financial Bank
# Five Star Bank (NY)
# CENTRAL STAR CU
# Lone Star CU
# Star Harbor FCU - Investments
# Lone Star National Bank
# STAR CU - Investments
# Five Star Bank (CA)
# .......

```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add yodlee to your list of dependencies in `mix.exs`:

        def deps do
          [{:yodlee, "~> 0.1.0"}]
        end

  2. Ensure yodlee is started before your application:

        def application do
          [applications: [:yodlee]]
        end
