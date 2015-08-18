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
    render json: @rental
  end

  def deny
    CatRentalRequest.find(params[:id]).deny!
    render text: "Denied #{params[:id]}"
  end
end
