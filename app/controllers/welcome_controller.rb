class WelcomeController < ApplicationController
  def index
  end

  def team 
  	
  end

  def show
  	@message = Message.new
  end

  def testpage 
  	seat = Library.find_by_name('machine shop').seats.first
    @status = seat.status

  end 
end
