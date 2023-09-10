class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :login, :forgot_password, :reset_password]
  before_action :check_administrator, only: :destroy

  def show
    render json: @current_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message:"User Created!!!", data: @user }
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @current_user.update(user_params)
      render json: { message: 'User updated', data: @current_user}
    else
      render json: { errors: @current_user.errors.full_messages }
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      render json: { message: 'User deleted' }
    else
      render json: { errors: @current_user.errors.full_messages }
    end
  end
  

  def login
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { message: "Logged In Successfully..", token: token }
    else
      render json: { error: "Please Check your Email And Password....."}  
    end
  end

  def forgot_password
    user = User.find_by(email: params[:email])
    if user
      user.password_reset_token = SecureRandom.urlsafe_base64
      user.password_reset_sent_at = Time.current
      user.save!
      UserMailer.reset_password_instructions(user).deliver_now
      render json: { message: 'Password reset instructions sent to your email.' }, status: :ok
    else
      render json: { error: 'Email not found. Please try again.' }, status: :not_found
    end
  end

  # Reset password
  def reset_password
    user = User.find_by(password_reset_token: params[:token])
    if user && user.password_reset_sent_at > 1.hour.ago
      user.update(password: params[:new_password], password_reset_token: nil, password_reset_sent_at: nil)
      render json: { message: 'Password successfully reset.' }, status: :ok
    else
      render json: { error: 'Invalid or expired reset token.' }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:name, :email, :password, :type)
  end
end
