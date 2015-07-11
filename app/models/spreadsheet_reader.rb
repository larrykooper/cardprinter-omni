module SpreadsheetReader

    # Adapted from gimite (Hiroshi Ichikawa) with thanks
    # https://github.com/gimite/google-drive-ruby

    require "rubygems"
    require "google/api_client"
    require "google_drive"
    require "json"

    @@session = nil
    # MAINTENANCE
    @@headings = [:lo_number, :on_now?, :secret_number, :outside_inside,
       :only_nyt?, :category_tag, :long_description, :card_description, :would_make_me_happy?, :priority,
       :create_date, :finishable?, :g_r,  :prio_notes, :evernote_note, :link_1,
       :swiss_cheese, :project?, :bucket_list?, :has_card?]

    def SpreadsheetReader.get_sheet_data
        access_token = Token.last.fresh_token
        @@session = GoogleDrive.login_with_oauth(access_token)
        puts 'MESSAGE 17 - spreadsheet_reader.rb'

        # worksheets[0] is first worksheet
        # LIVE_GR_SHEET_KEY is the live one
        # TEST_GR_SHEET_KEY is the test one
        begin
            ws = @@session.spreadsheet_by_key(ENV['TEST_GR_SHEET_KEY']).worksheets[0]
        rescue Exception => e
            puts "I am in rescue"
            puts "#{$!}"
            puts e.Message
            puts e.backtrace.inspect
        end
        # Return the spreadsheet data by rows
        # As: [["fuga", "baz"], ["foo", "bar"]]
        puts 'Message 28 - spreadsheet_reader.rb'
        data_as_array = ws.rows
        hashes_array = SpreadsheetReader.convert_data(data_as_array)
        hashes_array.to_json
    end

    def SpreadsheetReader.convert_data(data_as_array)
        hashes_array = Array.new
        first_row = true
        data_as_array.each do |row_array|
            if not first_row
                data_hash = {}
                i = 0
                row_array.each do |cell_string|
                    data_hash[@@headings[i]] = cell_string
                    i += 1
                end
                hashes_array << data_hash
            else
                first_row = false
            end
        end
        hashes_array
    end

end
