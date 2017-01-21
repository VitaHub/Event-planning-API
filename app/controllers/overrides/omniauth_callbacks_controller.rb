module Overrides
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    after_action :update_auth_header, only: :omniauth_success

    def assign_provider_attrs(user, auth_hash)
      user.assign_attributes({
        nickname: auth_hash['info']['nickname'],
        name:     auth_hash['info']['name'],
        email:    auth_hash['info']['email']
      })
    end
  end
end