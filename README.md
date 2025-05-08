# README

1. Please make sure that you follow all the pre-requisite steps/instructions from the #Pre-Requisites.md.

2. This application was bootstrapped by using the following command (no database was needeed for the initial version):
   rails new weather_forecast_app --skip-active-record

3. As the Rails cache is not enabled by default, there was a DEV OVERRIDE done in the file 'config/environments/development.rb' to enable caching.
   (For simlicity, in this intial version of the app, Rails caching approach was taken. Otherwise, for serious, spohisticated production grade usage, this version of the app will be enhanced to use Redis cache).

4. Sign-up for a new, free account at https://www.weatherapi.com/signup.aspx. After finishing the sign-up, log-on to the web portal and make a note of your API Key.

5. To get the app. running very quickly, please copy 'config/.env' to the root level and update the following ENV value with your actual API Key (from Step-4):
   WEATHER_API_KEY=<Fill-in-Your-Actual-API-Key>

6. Launch the app by executing the command 'rails s' and access the local application at http://localhost:3000.


