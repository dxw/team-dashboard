require 'opsgenie'

Opsgenie.configure(api_key: ENV.fetch("OPSGENIE_API_KEY"))
