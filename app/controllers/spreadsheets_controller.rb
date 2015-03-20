class SpreadsheetsController < ApplicationController

    def get_sheet_data
        @data = SpreadsheetReader.get_sheet_data
        respond_to do |format|
            format.json {
                render json: @data
            }
            format.text {
                render :text => @data
            }
        end
    end

end
