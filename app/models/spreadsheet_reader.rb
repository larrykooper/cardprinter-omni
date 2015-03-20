module SpreadsheetReader

    def SpreadsheetReader.get_sheet_data

        # Do http request
        access_token = Token.last.fresh_token

        full_url = 'https://spreadsheets.google.com/feeds/spreadsheets/private/full'
        uri = URI.parse(full_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)

        request['authorization'] = "Bearer #{access_token}"

        response = http.request(request)
        #response.body is the stuff you want
        puts response.body

    end

end
