class WelcomeController < ApplicationController
  def index
  end

  def team 
  	
  end

  def show
  	@message = Message.new
  end
end
