source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails',                    '~> 5.0.1'
gem 'pg',                       '~> 0.18'
gem 'puma',                     '~> 3.0'
gem 'rack-cors'
gem 'active_model_serializers', '~> 0.10.0'
gem 'validates_timeliness',     '~> 4.0'
gem 'rails-controller-testing'
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-base64'
gem 'rspec_api_documentation'
gem 'apitome'
gem 'devise'
gem 'devise_token_auth'
gem 'omniauth'
gem 'omniauth-github'
gem 'public_activity'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :development do
  gem 'listen',                 '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen',  '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
