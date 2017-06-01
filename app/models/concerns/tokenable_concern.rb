module TokenableConcern
  extend ActiveSupport::Concern

  included do
    has_many :tokens, as: :tokenable, dependent: :destroy
  end

  def create_token(scope, **opts)
    self.tokens.create(
         scope: scope,
         **opts
    )
  end

end