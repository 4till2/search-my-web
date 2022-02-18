def create_page
  Page.create! url: "https://#{SecureRandom.alphanumeric(5)}.com"
end

def create_source(account, s)
  Source.create account: account, sourceable: s
end

def create_user
  User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: 'asdfasdf', password_confirmation: 'asdfasdf', account_attributes: { nickname: SecureRandom.alphanumeric(10) }
end

100.times { create_user }

100.times { create_page }

90.times { |i| create_source(Account.find(i + 10), Page.first) }

