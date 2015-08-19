class CatsController < ApplicationController
  before_action :editor_owns_cat, only: [:edit, :update]

  helper_method :user_owns_cat?

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @rentals = @cat.cat_rental_requests.order(:start_date)
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  def user_owns_cat?
    current_user.id == Cat.find(params[:id]).user_id
  end

  private
  def cat_params
    params.require(:cat).permit(:name,:sex,:color,:description,:birthdate)
  end

  def editor_owns_cat
    redirect_to cats_url unless current_user.id == Cat.find(params[:id]).user_id
  end
end
