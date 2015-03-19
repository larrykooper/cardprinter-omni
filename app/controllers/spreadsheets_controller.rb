class SpreadsheetsController < ApplicationController
    def get_sheet_data
        SpreadsheetReader.get_sheet_data

    end
end
