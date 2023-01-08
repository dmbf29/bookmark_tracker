class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit::Authorization
  include JsonWebToken
  attr_reader :current_user

  before_action :authenticate_request, unless: :skip_pundit?
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  def authenticate_request
    # p header = request.headers['Authorization']
    p header = params[:token]
    header = header.split(" ").last if header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
