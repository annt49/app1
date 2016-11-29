class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = params[:title].capitalize
    @user = User.find_by id: params[:id]
    if @user.nil?
      flash[:danger] = "Error!"
      redirect_to root_path
    else
      @users = @user.send(params[:title]).paginate page: params[:page]
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user.nil?
      flash[:danger] = "Error!"
      redirect_to root_path
    else
      current_user.follow @user
      @relationship = current_user.active_relationships.find_by followed_id:
        @user.id
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    @relationship = current_user.active_relationships.build
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
