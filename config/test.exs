use Mix.Config

config :yodlee,
  request_handler: Yodlee.MockHandler,
  api_base_url: "http://localhost"
