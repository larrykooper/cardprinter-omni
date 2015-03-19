# This pattern will be used often in the twilio examples
# For production code we would DRY it up

require 'pp'
task :list_labels => :environment do
    # Create a Google API client
    client = Google::APIClient.new

    # Use our OAuth Token
    client.authorization.access_token = Token.last.fresh_token

    # Tell Google which API to use
    service = client.discovered_api('gmail')

    # Tell Google which method to call and which user to access
    result = client.execute(
        :api_method => service.users.labels.list,
        :parameters => {'userId' => 'me'},
        :headers => {'Content-Type' => 'application/json'})

    # Google returns some JSON, which we turn into a hash using the Ruby JSON library
    pp JSON.parse(result.body)
end
