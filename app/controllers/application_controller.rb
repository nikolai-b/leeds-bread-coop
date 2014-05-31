class ApplicationController < NotAdminApplicationController
  before_action :authenticate_admin, unless: :devise_controller?
end
