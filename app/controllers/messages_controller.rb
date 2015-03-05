class MessagesController < ApplicationController
	include ActionController::Live
	def create
		@message = Message.new(message_params)
		@message.save!
		# redirect_to 'welcome_url'
		render nothing: true
	end

def events
  response.headers["Content-Type"] = "text/event-stream"
  start = Time.zone.now-10
    Status.uncached do
      Status.where('created_at > ?', start).each do |status|
        response.stream.write "data: #{status.to_json}\n\n"
        logger.info "Processing the request..."
        logger.info status

        start = Time.zone.now-10
     end 
   end

rescue IOError
  logger.info "Stream closed"
ensure
  response.stream.close
end

private
  	def message_params
      params.require(:message).permit(:message, :email, :name)
    end
end
