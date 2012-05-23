require 'yaml'
require 'faker'

users = []

10.times do
  users << {
    first: Faker::Name.first_name,
    last: Faker::Name.last_name,
    age: (rand * 80).floor
  }
end

File.open 'users.yaml', 'w' do |f|
  f.write users.to_yaml
end
