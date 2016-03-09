use Mix.Config

config :yodlee,
  request_handler: Yodlee.Handler,
  api_base_url: System.get_env("YODLEE_BASE_URL"),
  default_cobrand_name: System.get_env("YODLEE_DEFAULT_COBRAND_NAME")

config :logger,
  level: :debug
