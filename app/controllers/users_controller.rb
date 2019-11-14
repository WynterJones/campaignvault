class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_users
  before_action :set_user_update, only: [:update, :edit, :destroy]
  breadcrumb 'Users', ''

  def index
    set_meta_tags title: 'Users'
  end

  def new
    set_meta_tags title: 'New User'
    breadcrumb 'New', ''
    @user = User.new
  end

  def edit
    set_meta_tags title: 'Edit User'
    breadcrumb 'Edit', ''
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to '/users', notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to '/users', notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to '/users', notice: 'User was successfully deleted.' }
    end
  end

  private

    def set_users
      if current_user.id != 1
        redirect_to '/'
      else
        @users = User.all.order(id: :asc).paginate(page: params[:page], per_page: params[:per_page] || 25)
      end
    end

    def set_user_update
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
