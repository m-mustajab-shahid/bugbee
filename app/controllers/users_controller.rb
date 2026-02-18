class UsersController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def edit
  end



  # Profile Management

  def profile
    @user = current_user
  end

  def updateProfilePhoto
    @uploaded_file = params[:profile_photo]

    if @uploaded_file.present?
      current_user.profile_photo.attach(@uploaded_file)

      if current_user.save
        flash[:success] = "Profile photo updated successfully!"
      else
        flash[:error] = "Something went wrong while saving."
      end
    else
      flash[:alert] = "Please select a file first."
    end
    redirect_back(fallback_location: root_path)
  end

def updateProfile
  @user = current_user

  if @user.update(profile_params)
    flash[:success] = "Profile updated successfully!"
    redirect_to profile_path
  else
    flash.now[:error] = "Something went wrong while saving."
    render :profile, status: :unprocessable_entity
  end
end



  private

def profile_params
  params.permit(:full_name, :email, :password)
end
end
