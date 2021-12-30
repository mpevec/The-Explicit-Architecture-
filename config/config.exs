import Config

config :propy,
  cowboy_port: 4001,
  ecto_repos: [Propy.Repo],
  jwt_issuer: "Matthieu Labs SRL",
  jwt_secret_hs256_signature: "asdwf12!weWEFWEWEFdfw123fweWEF!!Dcwcw?"

# Identity context
config :propy, Propy.Identity.Core.IAdaptSystem, Propy.Identity.Infra.SystemAdapter
config :propy, Propy.Identity.Core.IAdaptJwt, Propy.Identity.Infra.JwtAdapter
config :propy, Propy.Identity.Core.IManageIdentity, Propy.Identity.Core.Service.Identity
config :propy, Propy.Identity.Core.Service.IManageRepository, Propy.Identity.Core.Repository.Identity

# Statistics context
config :propy, Propy.Statistics.Core.IAdaptSystem, Propy.Statistics.Infra.FixedSystemAdapter
config :propy, Propy.Statistics.Core.IManageStatistics, Propy.Statistics.Core.Service.Statistics
config :propy, Propy.Statistics.Core.Service.IManageRepository, Propy.Statistics.Core.Repository.Statistics

config :propy, Propy.Repo,
  url: "ecto://propy_user:pr272@localhost:5432/propy"

import_config "#{Mix.env()}.exs"
