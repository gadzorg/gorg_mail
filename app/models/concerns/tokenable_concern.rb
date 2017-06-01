module TokenableConcern
  extend ActiveSupport::Concern

  included do
    has_many :mail_tokens, as: :tokenable
  end

  def create_token(scope, **opts)
    self.mail_tokens.create(
                   scope: scope,
                   **opts
    )
  end

end