Setting.init rescue false

DOMAIN_NAMES = {"development" => "http://localhost:3000", "production" =>  "http://localhost:3000", "test" => "http://localhost:3000"}
DOMAIN_NAME = DOMAIN_NAMES[Rails.env]
