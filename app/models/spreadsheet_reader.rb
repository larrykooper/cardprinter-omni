module SpreadsheetReader

    def SpreadsheetReader.get_sheet_data
        client = Google::APIClient.new(
            :application_name => 'Card Printer',
            :application_version => '0.0.1'
        )
        client.authorization.access_token = Token.last.fresh_token
        service = client.discovered_api('drive')
        #puts "Title \t ID \t Preferred"
        #client.discovered_apis.each do |gapi|
        #    puts "#{gapi.title} \t #{gapi.id} \t #{gapi.preferred}"
        #end
    end

end
