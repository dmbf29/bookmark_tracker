class Api::V1::BaseController < ActionController::API
  include Pundit::Authorization
  include JsonWebToken
  attr_reader :current_user

  before_action :authenticate_request, unless: :skip_pundit?
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError,   with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def user_not_authorized(exception)
    render json: {
      error: "Unauthorized #{exception.policy.class.to_s.underscore.camelize}.#{exception.query}"
    }, status: :unauthorized
  end

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def authenticate_request
    p header = request.headers['Authorization']
    header = header.split(" ").last if header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  end

  def skip_pundit?
    params[:controller] =~ /(^(rails_)?admin)|(^pages$)|(^api.v1.authentication)/
  end

end
