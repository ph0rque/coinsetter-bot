class SecretConfig
  
  def self.username
    return 'ph0rque'
  end
  
  def self.password
    return '^4RHj2I3$NHqc5Uy4rZPftuyJQrMQ4mI@ma&fzm'
  end
  
  def self.quotaguard_static_url
    'http://quotaguard2197:8016aaab1f58@us-east-1-static-brooks.quotaguard.com:9293'
  end
  
  def self.coinsetter_url
    'https://staging-api.coinsetter.com/v1'
  end
  
  def self.coinsetter_username
    'h8ruqh6cbp68s5je4nrt9gvdnktu06n'
  end
  
  def self.coinsetter_password
    '1bac0945-6bdf-40ee-8cf7-a8d4dac294a9'
  end
  
  def self.coinsetter_customer_uuid
    'b1972ba8-ec90-40a4-93eb-11b56638006e'
  end
  
  def self.coinsetter_account_uuid
    '68e7468b-de54-4625-9f37-f4d4e9f907b0'
  end
  
  def self.coinsetter_login_params(ip_address)
    {
      username: self.coinsetter_username,
      password: self.coinsetter_password,
      ipAddress: ip_address,
      :accept => :json
    }
  end
  
end