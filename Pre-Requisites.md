# Assuming that you will use WSL (if you are on Windows). For Linux (Ubuntu & others) and Mac similar instructions are expected work.
1. Install Ruby version 3.0.0 --> Instructions can be followed from this link: https://dev.to/jessalejo/installing-ruby-using-rbenv-on-your-wsl-ubuntu-system-183f (If you want to use higher versions, please choose one and update the version in the files .ruby-version & Gemfile).

2. Install Rails version 7.1.5 using the following command:
   gem install rails -v 7.1.5

3. Update the Gemfile to add the 'httparty', 'dotenv-rails', 'rspec-rails' and 'simplecov'.

4. Finish installing all bundles:
   bundle install 

5. Generate test spec initial package:
   rails generate rspec:install

6. Enable code coverage tooling by inserting the following 2 lines at the begining of 'spec/spec_helper.rb':
   require 'simplecov'
   SimpleCov.start 

