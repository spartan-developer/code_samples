class CatchesController < ApplicationController

  expose(:catches) { current_user.catches }
  expose :catch

  def index
    render :json => catches.map(&:attributes)
  end

  def create
    render :json => catch.save ? 'success' : 'error'
  end

  def show
    render :json => catch.attributes
  end

  def destroy
    catch.destroy
    render :json => 'success'
  end

end
