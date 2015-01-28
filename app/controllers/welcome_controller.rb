class WelcomeController < ApplicationController
  def index
  end

  def show
  	@message = Message.new
  end
end
