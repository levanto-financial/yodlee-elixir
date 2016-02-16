# Yodlee [![Build Status](https://travis-ci.org/levanto-financial/yodlee-elixir.svg?branch=master)](https://travis-ci.org/levanto-financial/yodlee-elixir)


Yodlee Aggregation API for Elixir 

## Example Use

1. Setup your cobrand credentials, and run the main script

```sh
COBRAND_USERNAME=sbCobREPLACE_WITH_COBRAND_USERNAME \
COBRAND_PASSWORD=REPLACE_WITH_COBRAND_PASSWORD \
EXAMPLE_USER_LOGIN=A_TEST_USER_LOGIN \
EXAMPLE_USER_PASSWORD=A_TEST_USER_PASSWORD \
iex -S mix run lib/yodlee.ex 

```

2. Play!

You can login as your registered cobrand, and then make other API calls that depend on that token
```ex

case Yodlee.Auth.run_as_cobrand(
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
case Yodlee.Auth.run_as_cobrand_and_user(
      System.get_env("COBRAND_USERNAME"),
      System.get_env("COBRAND_PASSWORD"),
      System.get_env("EXAMPLE_USER_LOGIN"),
      System.get_env("EXAMPLE_USER_PASSWORD"),
      fn cobrand_session_tok, user_session_tok -> 

        "Your user token is #{user_session_tok}"

      end) do
  {:ok, result} -> IO.puts "Result: #{result}"
  {:error, result} -> IO.inspect result
end

# Result: Your user token is 08062qdwhiqwd......ea9c

```

And then user that user session token to do something like search for banking institutions

```ex

case Yodlee.Auth.run_as_cobrand_and_user(
      System.get_env("COBRAND_USERNAME"),
      System.get_env("COBRAND_PASSWORD"),
      System.get_env("EXAMPLE_USER_LOGIN"),
      System.get_env("EXAMPLE_USER_PASSWORD"),
      fn cobrand_session_tok, user_session_tok -> 
        case Yodlee.Site.search(cobrand_session_tok, user_session_tok, "PNC") do
          {:ok, sites} ->
            Enum.map sites, fn site -> 
              "#{site["defaultOrgDisplayName"]} - #{site["defaultDisplayName"]}"
            end
        end

      end) do

  {:ok, sites} ->
    IO.puts "Found #{Enum.count(sites)} sites"
    Enum.each sites, fn site -> IO.puts site end      

  {:error, result} -> IO.inspect result
end

# Found 10 sites
# Hewitt Management Company - PNC (My Benefits Access)
# PNC Bank - PNC Bank
# National City - PNC Bank (Elan) - Credit Cards
# National City - PNC Bank (Hewitt)
# National City - PNC Bank (Small Business)
# Provident Bank - PNC Bank (formerly Provident Card (OH))
# PNC Bank - PNC Bank Small Business (Account View)
# National City - PNC Home Equity Online
# National City - PNC Mortgage
# National City - PNC Vested Interest (Participant Login)

```

Or even something more complicated like adding a "site account" to the user

```ex

case Yodlee.Auth.run_as_cobrand_and_user(
  System.get_env("COBRAND_USERNAME"),
  System.get_env("COBRAND_PASSWORD"),
  System.get_env("EXAMPLE_USER_LOGIN"),
  System.get_env("EXAMPLE_USER_PASSWORD"),
  fn cobrand_session_tok, user_session_tok -> 
    
    case Yodlee.SiteAccount.get_form(cobrand_session_tok, 16441) do
      {:ok, site_form} ->
        
        # Ask user for data, to fill in form
        form_data = Enum.map site_form["componentList"], fn c ->
          x = IO.gets("#{c["displayName"]}: ") |> String.replace("\n", "")
          %{value: x,
            name: c["name"],
            valueIdentifier: c["valueIdentifier"]
          }
        end

        # Pass the filled in form to Yodlee
        case Yodlee.SiteAccount.add(cobrand_session_tok, user_session_tok,
          16441, # Site ID
          hd(site_form["componentList"])["fieldInfoType"], # com.yodlee.common.FieldInfoSingle
          form_data) do
          {:ok, site_acct_info} -> site_acct_info
          {:error, err} ->
            raise "Error creating site account"
        end

      {:error, err} ->
        raise "Error getting site form data"
    end
  end) do

  {:ok, account} ->
    IO.puts "New site account created! " <>
      account["siteInfo"]["defaultDisplayName"] <> " " <>
      to_string(account["siteAccountId"])
    account
  {:error, result} -> IO.inspect result
end

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add yodlee to your list of dependencies in `mix.exs`:

        def deps do
          [{:yodlee, "~> 0.0.7"}]
        end

  2. Ensure yodlee is started before your application:

        def application do
          [applications: [:yodlee]]
        end
