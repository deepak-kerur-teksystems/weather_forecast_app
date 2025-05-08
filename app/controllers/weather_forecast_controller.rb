class WeatherForecastController < ApplicationController
    def index; end
  
    def display
      @address = params[:address]
      service = WeatherForecastService.new(@address)
      @forecast = service.fetch_forecast || {}
      @zip = AddressZipCodeExtractor.extract(@address)
    end
  end
