class MessagesController < ApplicationController
	def create
		@message = Message.new(message_params)
		@message.save!
		# redirect_to 'welcome_url'
		render nothing: true
	end
private
  	def message_params
      params.require(:message).permit(:message, :email, :name)
    end

end
