# app/controllers/sessions_controller.rb
# https://www.twilio.com/blog/2014/09/gmail-api-oauth-rails.html
class SessionsController < ApplicationController
    #layout false

    # 'new' renders a view that kicks off the
    #    authorization process - it provides a link that
    #    links to '/auth/google_oauth2'
    def new
    end

    # 'create' is the oauth2 callback we give to Google
    def create
        puts "MESSAGE 14 IN CREATE"
        @auth = request.env['omniauth.auth']['credentials']
        # The following statement saves the tokens to the database
        Token.create(
            access_token: @auth['token'],
            refresh_token: @auth['refresh_token'],
            expires_at: Time.at(@auth['expires_at']).to_datetime)
    end

end
