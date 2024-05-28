Cloudinary.config do |config|
    if Rails.env.test?
      config.cloud_name = 'docca4t8j'
      config.api_key = '466253913145971'
      config.api_secret = 'ajZCzPjbtjQFrZTj0J2Jj0yT7eA'
    else
      config.cloud_name = 'dkrmah0f7'
      config.api_key = '183549582925518'
      config.api_secret = 'LRDlCyJxSBI03yiQzOGQZpBdrvA'
    end
  end