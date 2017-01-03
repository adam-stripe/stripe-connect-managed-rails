class RegistrationsController < ApplicationController
  def after_sign_up_path_for(user)
    new_campaign_path
  end
end