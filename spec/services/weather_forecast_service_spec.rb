require 'rails_helper'

RSpec.describe WeatherForecastService do
  it 'returns forecast data for a valid US ZIP' do
    allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: {
      "location" => { "name" => "City", "region" => "State", "country" => "USA" },
      "current" => { "temp_c" => 20, "temp_f" => 68 },
      "forecast" => {
        "forecastday" => [{
          "date" => "2025-05-08",
          "day" => {
            "maxtemp_c" => 25, "mintemp_c" => 15,
            "maxtemp_f" => 77, "mintemp_f" => 59,
            "condition" => { "text" => "Sunny" }
          }
        }]
      }
    }))
    result = WeatherForecastService.new("2651 NE 49th St, Seattle, WA 98105").fetch_forecast
    expect(result[:current_temp_c]).to eq(20)
    expect(result[:forecast_days].first[:date]).to eq("2025-05-08")
  end

  it 'returns forecast data for a valid Canada ZIP' do
    allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: {
      "location" => { "name" => "City", "region" => "State", "country" => "CA" },
      "current" => { "temp_c" => 15, "temp_f" => 59 },
      "forecast" => {
        "forecastday" => [{
          "date" => "2025-05-08",
          "day" => {
            "maxtemp_c" => 20, "mintemp_c" => 10,
            "maxtemp_f" => 68, "mintemp_f" => 50,
            "condition" => { "text" => "Snowy" }
          }
        }]
      }
    }))
    result = WeatherForecastService.new("123 Main Street, Suite 400, Montreal, QC H2Y 2R7").fetch_forecast
    expect(result[:current_temp_c]).to eq(15)
    expect(result[:forecast_days].first[:date]).to eq("2025-05-08")
  end
end
