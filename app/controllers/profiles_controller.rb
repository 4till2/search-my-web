class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_and_authorize, only: %i[show edit update destroy]

  def index
    authorize Profile
    @profiles = Profile.all
  end

  def show; end

  def new
    user = current_user
    if user.nil?
      redirect_to signup_path
    elsif user.account.nil?
      redirect_to new_account_path
    else
      @profile = Profile.new
    end
  end

  def edit; end

  def create
    @profile = Profile.new(profile_params)
    @profile.account = current_user&.account

    respond_to do |format|
      if @profile.save
        format.html { redirect_to profile_url(@profile), notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to profile_url(@profile), notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def load_and_authorize
    @profile = Profile.find(params[:id])
    authorize @profile
  end

  def profile_params
    params.require(:profile).permit(:title, :avatar, :bio)
  end
end
