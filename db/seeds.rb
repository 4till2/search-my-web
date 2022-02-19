def create_page
  Page.create! url: "https://#{SecureRandom.alphanumeric(5)}.com"
end

def create_source(account, s)
  Source.create account: account, sourceable: s
end

def create_user
  User.create! email: "#{Faker::ProgrammingLanguage.name}@mail.com", password: 'asdfasdf', password_confirmation: 'asdfasdf', account_attributes: { nickname: Faker::Twitter.screen_name }
end

puts create_user.email
# 2.times { create_user }

# 2.times { create_page }

# 2.times { |i| create_source(Account.find(i + 10), Page.first) }

