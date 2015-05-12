class WelcomeController < ApplicationController
  def index
  end

  def team 
  	
  end

  def show
  	@message = Message.new
  end

  def testpage 
  	@seat = Library.find_by_name('machine shop').seats.first
    @seat.status = params[:status]
    @seat.save!

    @status = (@seat.status == 1) ? 'ON' : 'OFF'
  end 
end
