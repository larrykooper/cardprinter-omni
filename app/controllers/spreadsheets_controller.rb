class SpreadsheetsController < ApplicationController

    def get_sheet_data
        begin
            @data = SpreadsheetReader.get_sheet_data
        rescue
            render :json => {:errors => "There has been a Ruby exception"}, :status => 500
            return
        end
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
