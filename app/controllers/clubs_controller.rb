class ClubsController < ApplicationController
  before_action :find_club, only: [:show, :edit, :update]
  before_action :ensure_login, except: [:index]
  before_action :ensure_role, only: [:show]
  before_action :ensure_ownership, only: [:edit, :update]

  def index
    @clubs = Club.all
  end

  def show
  end

  def new
    @club = Club.new
  end

  def create
    @club = Club.new(
      name: params[:club][:name],
      description: params[:club][:description],
      user: current_user
    )

    if @club.save
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @club && @club.update(name: params[:club][:name], description: params[:club][:description], user: current_user)
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :edit
    end
  end

  private

  def ensure_login
    if !session[:user_id]
      flash[:alert] = ["You must be logged in!"]
      redirect_to root_path
    end
  end

  def ensure_ownership
    if session[:user_id] != @club.user_id
      flash[:alert] = ["You don't own this club!"]
      redirect_to root_path
    end
  end

  def ensure_role
    if Club.banned.include?(current_user.role)
    # if current_user.role == "droids" || current_user.role == "gangster"
      flash[:alert] = ["No gangsters or droids allowed!"]
      redirect_to root_path
    end
  end

  def find_club
    @club = Club.find(params[:id])
  end

end
