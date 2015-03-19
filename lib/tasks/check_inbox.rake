require 'pp'
LABEL_ID = 'Label_69'  #  max
task :check_inbox => :environment do
  client = Google::APIClient.new
  client.authorization.access_token = Token.last.fresh_token
  service = client.discovered_api('gmail')
  result = client.execute(
    :api_method => service.users.messages.list,
    :parameters => {'userId' => 'me', 'labelIds' => ['INBOX', LABEL_ID]},
    :headers => {'Content-Type' => 'application/json'})
  pp JSON.parse(result.body)
end
