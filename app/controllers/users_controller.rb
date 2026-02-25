class UsersController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_user, only: [ :edit, :update, :destroy ]

  def index
    authorize User
    per_page = params[:per_page].present? ? params[:per_page].to_i : 3
    @users = User.all.page(params[:page]).per(per_page)
  end

  def new
    authorize User
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "User was successfully created!"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize User
  end

  def update
    authorize User
    filtered_params = user_params
    if filtered_params[:password].blank?
      filtered_params = filtered_params.except(:password, :password_confirmation)
    end
    if @user.update(filtered_params)
      redirect_to users_path, notice: "User updated successfully!"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize User
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully!"
  end

  # Profile Management
  def profile
    @user = current_user
  end

  def update_profile_photo
    @user = current_user
    if params[:profile_photo].present?
      if @user.update(profile_photo: params[:profile_photo])
        redirect_back(fallback_location: root_path, notice: "Photo updated successfully!")
      else
        flash[:alert] = @user.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:alert] = "Please select a file first."
      redirect_back(fallback_location: root_path)
    end
  end

  def update_profile
    @user = current_user
    if @user.update(profile_params)
      flash[:success] = "Profile updated successfully!"
      redirect_to "/users/sign_in"
    else
      flash.now[:error] = "Something went wrong: #{@user.errors.full_messages.to_sentence}"
      respond_to do |format|
        format.html { render :profile, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend("toast-container",
            partial: "shared/toast",
            locals: { type: "error", message: flash.now[:error] })
        }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :full_name,
      :email,
      :password,
      :password_confirmation,
      :role,
      :status
    )
  end

  def profile_params
    params.permit(:full_name, :email, :password, :password_confirmation)
  end
end
