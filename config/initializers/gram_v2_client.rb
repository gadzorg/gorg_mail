GramV2Client.configure do |c|
   # Base URI used to access GrAM API
   c.site=Rails.application.secrets.gram_api_site
   # Username provided by Gadz.org
   c.user=Rails.application.secrets.gram_api_user
   # Password provided by Gadz.org
   c.password=Rails.application.secrets.gram_api_password
   # If your app use a proxy to access net, put it here
   #c.proxy="my_proxy"
end