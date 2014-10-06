class RegistrationsController < Devise::RegistrationsController
  def update
    @subscriber = Subscriber.find(current_subscriber.id)

    successfully_updated = if needs_password?(@subscriber, params)
      @subscriber.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:subscriber].delete(:current_password)
      @subscriber.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      sign_in @subscriber, :bypass => true
      redirect_to after_update_path_for(@subscriber)
    else
      render "edit"
    end
  end

  def destroy
    StripeSub.new(@subscriber).cancel
    super
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
