class UsersController < ApplicationController
  before_action :redirect_if_signed_in!, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      redirect_to "#/rides"
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def destroy
  end

  def update
  end

  def show
    @user = current_user
  end

  def index
  end

  private

  def user_params
    params.require(:user).permit(:password, :email, :username)
  end
end
