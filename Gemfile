source "https://rubygems.org/"

# Server requirements
# gem 'thin' # or mongrel
gem 'unicorn'

# gem 'trinidad', :platform => 'jruby'

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'rack-google-analytics', :require => "rack/google-analytics"
gem 'omniauth'
gem 'rack-recaptcha', :require => "rack/recaptcha"
gem 'bcrypt-ruby', :require => "bcrypt"
gem 'rack-less'
gem 'less'
gem 'erubis', "~> 2.7.0"
gem 'dm-validations'
gem 'dm-timestamps'
gem 'dm-migrations'
gem 'dm-constraints'
gem 'dm-aggregates'
gem 'dm-core'

gem 'therubyracer'

gem 'foreman'

group :development do
  gem 'dm-sqlite-adapter'
end

group :production do
 gem 'pg'
 gem 'do_postgres'
 gem 'dm-postgres-adapter'
end

# Test requirements
gem 'rspec'
gem 'rack-test'

# Padrino Stable Gem
gem 'padrino', '0.11.4'

gem 'twitter'

gem 'redis'

gem 'omniauth-twitter'

# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.10.7'
# end
  
