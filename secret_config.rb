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
    'https://api.coinsetter.com/v1'
  end
  
  def self.coinsetter_username
    'ph00rque'
  end
  
  def self.coinsetter_password
    '4d42raw$MXgSvk83VABnG^x*'
  end
  
  def self.coinsetter_customer_uuid
    '8d1e8d3f-a45e-421d-9d71-7c93277c797d'
  end
  
  def self.coinsetter_login_params(ip_address)
    {
      username: self.coinsetter_username,
      password: self.coinsetter_password,
      ipAddress: ip_address
    }
  end
  
end