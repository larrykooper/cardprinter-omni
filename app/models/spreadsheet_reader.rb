module SpreadsheetReader

    def SpreadsheetReader.get_sheet_data
        #client = Google::APIClient.new(
        #    :application_name => 'Card Printer',
        #    :application_version => '0.0.1'
        #)
        #client.authorization.access_token = Token.last.fresh_token
        #service = client.discovered_api('drive')
        #puts "Title \t ID \t Preferred"
        #client.discovered_apis.each do |gapi|
        #    puts "#{gapi.title} \t #{gapi.id} \t #{gapi.preferred}"
        #end

        # LKHERE do http request
        access_token = Token.last.fresh_token

        full_url = 'https://spreadsheets.google.com/feeds/spreadsheets/private/full'
        uri = URI.parse(full_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)

        request['authorization'] = "Bearer #{access_token}"

        response = http.request(request)
        #response.body is the stuff you want




    end

end
