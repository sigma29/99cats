class CatRentalRequestsController < ApplicationController
  def new
    @rental_request = CatRentalRequest.new
    @cats = Cat.all
    render :new
  end

  def create
    @rental_request = CatRentalRequest.new(rental_params)
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat_id)
    else
      @cats = Cat.all
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
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
end
