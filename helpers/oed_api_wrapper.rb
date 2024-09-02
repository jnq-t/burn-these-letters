module Helpers
  class OedApiWrapper
    require 'uri'
    require 'net/http'

    OED_LANGUAGE_CODE = "en-us"
    OED_BASE_URI = "https://od-api-sandbox.oxforddictionaries.com/api/v2"

    # endpoint = "entries"
    #     url = "https://od-api.oxforddictionaries.com/api/v2/" + endpoint + "/" + language_code + "/" + word_id.lower()
    #     r = requests.get(url, headers = {"app_id": app_id, "app_key": app_key})

    # # nethttp.rb
    # require 'uri'
    # require 'net/http'
    #
    # uri = URI('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY')
    # res = Net::HTTP.get_response(uri)
    # puts res.body if res.is_a?(Net::HTTPSuccess)
    def initialize(api_id, api_key)
      @api_id = api_id
      @api_key = api_key
    end

    def entry_for_word(word)
      request("entry", word.downcase)
    end


    def request(endpoint, word)
      request_url = OED_BASE_URI + "/" + endpoint + "/" + OED_LANGUAGE_CODE + "/" + word
      request = Net::HTTP::Get.new(URI(request_url))
      request["app_id"] = @app_id
      request["app_key"] = @app_key
      res = Net::HTTP.get_response(request_url)
      puts res
      # puts res.body if res.is_a?(Net::HTTPSuccess)
    end
  end
end