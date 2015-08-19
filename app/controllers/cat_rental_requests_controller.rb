class CatRentalRequestsController < ApplicationController
  before_action :user_owns_cat, only: [:approve, :deny]

  def new
    @rental_request = CatRentalRequest.new
    @cats = Cat.all
    render :new
  end

  def create
    @rental_request = current_user.rental_requests.new(rental_params)
    #debugger
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat_id)
    else
      @cats = Cat.all
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def rental_params
    params.require(:cat_rental_request)
      .permit(:start_date,:end_date,:cat_id,:status)
  end

  def approve
    @rental =CatRentalRequest.find(params[:id])
    @rental.approve!
    redirect_to cat_url(@rental.cat_id)
  end

  def deny
    @rental = CatRentalRequest.find(params[:id])
    @rental.deny!
    redirect_to cat_url(@rental.cat_id)
  end

  def index
    render :index
  end

  private

  def user_owns_cat
    cat = CatRentalRequest.find(params[:id]).cat
    unless current_user.id == cat.user_id
      redirect_to cat_url(cat.id)
    end
  end
end
