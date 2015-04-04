# app/models/token.rb
# https://www.twilio.com/blog/2014/09/gmail-api-oauth-rails.html

require 'net/http'
require 'json'

class Token < ActiveRecord::Base

    def fresh_token
        # public
        # A method to return a valid access token.
        #  It refreshes if necessary.
        refresh! if expired?
        access_token
    end

    def to_params
        # private
        # Converts the token's attributes into a hash
        #  with the key names that the Google API
        #  expects for a token refresh.
        #
        # GOOGLE'S DOCS:
        #   https://developers.google.com/accounts/docs/OAuth2WebServer#refresh
        {'refresh_token' => refresh_token,
        'client_id' => ENV['CARDPRINTER_CLIENT_ID'],
        'client_secret' => ENV['CARDPRINTER_CLIENT_SECRET'],
        'grant_type' => 'refresh_token'}
    end

    def request_token_from_google
        # private
        # called only from refresh!
        #
        # Makes an http POST request to the Google API OAuth 2.0
        #  authorization endpoint using the parameters from
        #  the to_params method.
        #
        # Google returns JSON data, that includes an access
        #   token good for another 60 minutes.
        #
        url = URI("https://www.googleapis.com/oauth2/v3/token")
        puts "In token model - Message 43"
        puts self.to_params
        response = Net::HTTP.post_form(url, self.to_params)
        if response.is_a?(Net::HTTPBadRequest)
            puts "Response is 'bad request'"
            raise Cardprinter::NeedsAuthentication, "Authentication needed"
        end
        puts "Response is NOT bad request"
        response
    end

    def refresh!
        # private
        # called only from fresh_token
        #
        # This method requests the token from Google,
        # parses its JSON response, and updates my database
        # with the new access token and expiration date.
        response = request_token_from_google
        puts "In token model - Message 64"
        puts response
        # skip 63-66 if bad
        data = JSON.parse(response.body)
        update_attributes(
            access_token: data['access_token'],
            expires_at: Time.now + (data['expires_in'].to_i).seconds)
    end

    def expired?
        # private
        # Returns true if my access token has expired
        expires_at < Time.now
    end

end
