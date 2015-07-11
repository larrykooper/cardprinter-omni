class SpreadsheetsController < ApplicationController

    def getdata
        begin
            sheet = params["sheet"]
            puts "Controller spreadsheets Message 6"
            puts "sheet is: " + sheet
            @data = SpreadsheetReader.get_sheet_data(sheet)
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
