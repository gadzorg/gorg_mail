# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( mail.css )

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.

## Assets pour Slack-Chat
Rails.application.config.assets.precompile += %w( slack-chat.min.js slack-chat.css slack-chat-custom.css slack-chat-caller.js email_redirect_tracking.js ml_tracking.js identicon.js pnglib.js)

