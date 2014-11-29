class RegistrationsController < Devise::RegistrationsController
  def update
    successfully_updated = if needs_password?(current_subscriber, params)
      current_subscriber.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:subscriber].delete(:current_password)
      current_subscriber.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      sign_in current_subscriber, :bypass => true
      redirect_to current_subscriber
    else
      render :edit
    end
  end

  protected

  def after_sign_up_path_for(resource)
    edit_stripe_sub_path(resource)
  end

  private

  def needs_password?(subscriber, params)
    subscriber.email != params[:subscriber][:email] ||
      params[:subscriber][:password].present?
  end

end
