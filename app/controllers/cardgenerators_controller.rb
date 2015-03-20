class CardgeneratorsController < ApplicationController
    include ::CardDrawer

    def generate_cards
        # TODO Put in a try/catch here or similar
        # to catch errors in the card generation

        @response = CardDrawer.generate_document(params[:data])
        respond_to do |format|
            format.json {
                render json: @data
            }
        end
    end
end