module SpreadsheetReader

    # Adapted from gimite (Hiroshi Ichikawa) with thanks
    # https://github.com/gimite/google-drive-ruby

    require "rubygems"
    require "google/api_client"
    require "google_drive"
    require "json"

    @@session = nil
    # MAINTENANCE
    @@gr_headings = [:lo_number, :on_now?, :secret_number, :outside_inside,
        :only_nyt?, :category_tag, :long_description, :card_description, :would_make_me_happy?,
        :priority, :create_date, :finishable?, :g_r,  :prio_notes, :evernote_note, :link_1,
        :swiss_cheese, :project?, :bucket_list?, :has_card?]

    @@lc_headings = [:lo_number, :secret_number, :category_tag, :long_description, :card_description,
        :priority, :finishable?, :prio_notes, :create_date, :evernote_note, :link_1,
        :would_make_me_happy?, :project?, :bucket_list?]

    def SpreadsheetReader.get_sheet_data(sheet)
        access_token = Token.last.fresh_token
        @@session = GoogleDrive.login_with_oauth(access_token)
        if sheet == 'gr'
            sheet_key = ENV['TEST_GR_SHEET_KEY']
            headings = @@gr_headings
        else
            sheet_key = ENV['LIVE_LC_SHEET_KEY']
            headings = @@lc_headings
        end
        sheet_key = sheet == 'gr' ? ENV['TEST_GR_SHEET_KEY'] : ENV['LIVE_LC_SHEET_KEY']
        puts "message 26 - spreadsheet_reader model"
        puts "sheet_key: " + sheet_key

        # worksheets[0] is first worksheet
        # LIVE_GR_SHEET_KEY is the live one
        # TEST_GR_SHEET_KEY is the test one
        begin
            ws = @@session.spreadsheet_by_key(sheet_key).worksheets[0]
        rescue Exception => e
            puts "I am in rescue"
            puts "#{$!}"
            puts e.Message
            puts e.backtrace.inspect
        end
        # Return the spreadsheet data by rows
        # As: [["fuga", "baz"], ["foo", "bar"]]
        puts 'Message 41 - spreadsheet_reader.rb'
        data_as_array = ws.rows
        hashes_array = SpreadsheetReader.convert_data(data_as_array, headings)
        hashes_array.to_json
    end

    def SpreadsheetReader.convert_data(data_as_array, headings)
        puts 'Message 49 - in convert_data'
        hashes_array = Array.new
        # Note that first row is column headings
        data_as_array.each do |row_array|
            data_hash = {}
            i = 0
            row_array.each do |cell_string|
                data_hash[headings[i]] = cell_string
                i += 1
            end
            hashes_array << data_hash
        end
        hashes_array
    end

end
