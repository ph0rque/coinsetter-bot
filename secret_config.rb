class SecretConfig

  def self.username
    'your-username-here'
  end

  def self.password
    'your-password-here'
  end

  def self.quotaguard_static_url
    'http://quotaguard2197:8016aaab1f58@us-east-1-static-brooks.quotaguard.com:9293'
  end

  def self.coinsetter_url
    'https://api.coinsetter.com/v1'
  end

  def self.coinsetter_username
    'coinsetter-username-here'
  end

  def self.coinsetter_password
    'coinsetter-password-here'
  end

  def self.coinsetter_customer_uuid
    '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d'
  end

  def self.coinsetter_account_uuid
    '5e6f7a8b-9c0d-1e2f-3a4b-5c6d5e6f7a8b'
  end

  def self.coinsetter_login_params(ip_address)
    {
      username: self.coinsetter_username,
      password: self.coinsetter_password,
      ipAddress: ip_address
    }
  end

end
