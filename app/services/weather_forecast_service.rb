require 'httparty'

class WeatherForecastService

# Weather API integration approach followed
# 1. Weather API key is stored in the ENV variable 'WEATHER_API_KEY' 
#    and it needs to be initialized in the environment
# 2. parse_forecast method is specific and will work only with the api.weatherapi.com response
WEATHER_FORECAST_API_URL = "https://api.weatherapi.com/v1/forecast.json"
WEATHER_FORECAST_DAYS = 3

  def initialize(address)
    @address = address
    begin
      @zip_code = AddressZipCodeExtractor.extract(address)
    rescue StandardError => e
      Rails.logger.error("Zip Code Extraction from the given address failed: #{e.message}")
      @zip_code = nil
    end
  end

  def fetch_forecast
    return { error: "Address format is wrong. Please retry with a valid address format." } unless @zip_code

    cache_expiration_time = (ENV['WEATHER_FORECAST_RESPONSE_CACHE_EXPIRATION_TIME']&.to_i || 30).minutes

    # Some loggers added for basic monitoring & troubleshooting purposes
    Rails.logger.info("WeatherForecastService >> Before HTTParty.get()")
    Rails.logger.info("WeatherForecastService >> WEATHER_API_KEY: #{ENV['WEATHER_API_KEY']}")
    Rails.logger.info("WeatherForecastService >> WEATHER_FORECAST_API_URL: #{WEATHER_FORECAST_API_URL}")
    Rails.logger.info("WeatherForecastService >> WEATHER_FORECAST_DAYS: #{WEATHER_FORECAST_DAYS}")
    Rails.logger.info("WeatherForecastService >> cache_expiration_time: #{cache_expiration_time}")
    Rails.logger.info("WeatherForecastService >> Address: #{@address}")
    Rails.logger.info("WeatherForecastService >> Zip Code: #{@zip_code}")

    cache_key = "weather_forecast_data_for_zip_#{@zip_code}"
    Rails.logger.info("WeatherForecastService >> cache_key: #{cache_key}")
  

    ###########################################################################################
    ##### Implementing a basic caching mechanism to avoid hitting the API too often.      #####
    ##### This can be improvized by using a more sophisticated caching strategy           #####
    ##### like Redis, but for the sake of this example, we are using Rails.cache directly #####
    ##### but for the sake of simplicity, Rails.cache has been used here.                 #####
    cached = Rails.cache.read(cache_key)
    Rails.logger.info("WeatherForecastService >> Cached data: #{cached.inspect}")
    return cached.merge(cached: true) if cached
    ###########################################################################################


    response = HTTParty.get(WEATHER_FORECAST_API_URL, query: {
      key: ENV['WEATHER_API_KEY'],
      q: @zip_code,
      days: WEATHER_FORECAST_DAYS,
      aqi: 'no',
      alerts: 'no'
    })
    Rails.logger.info("WeatherForecastService >> After HTTParty.get()")

    if response.success?
      data = response.parsed_response
      forecast = parse_forecast(data)
      Rails.cache.write(cache_key, forecast, expires_in: cache_expiration_time)
      forecast.merge(cached: false)
    else
      { error: "Something went wrong to retrieve the Weather API response." }
    end
  end

  private

  # Parses the forecast data from the API response
  # This works only for the Weather API response from the WEATHER_API
  def parse_forecast(data)
    {
      location: data["location"]["name"],
      region: data["location"]["region"],
      country: data["location"]["country"],
      current_temp_c: data["current"]["temp_c"],
      current_temp_f: data["current"]["temp_f"],
      forecast_days: data["forecast"]["forecastday"].map do |day|
        {
          date: day["date"],
          max_temp_c: day["day"]["maxtemp_c"],
          min_temp_c: day["day"]["mintemp_c"],
          max_temp_f: day["day"]["maxtemp_f"],
          min_temp_f: day["day"]["mintemp_f"],
          condition: day["day"]["condition"]["text"]
        }
      end
    }
  end
end
