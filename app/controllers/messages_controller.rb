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
  start = Time.zone.now-5
    Status.uncached do
      Status.where('created_at > ?', start).each do |status|
      	seat = Seat.new

      	if status.status =='free'
		color = '#00FF00'
		elsif status.status == 'busy'
			color = '#DC143C'
		else
			color = "#4682B4"
		end


      	seat.status = color
      	seat.uid = status.uid
      	seat.x = Seat.find_by_uid(status.uid).x
      	seat.y = Seat.find_by_uid(status.uid).y

      	seat_json = seat.to_json

      	seat_hash = JSON.parse(seat_json)


      	free_seat_count = 0
      	Seat.all.each do |seat|
      		if seat.status == 'free'
      			free_seat_count+=1
      		end
      	end

      	free_seat_percentage =free_seat_count.to_f/Seat.count*100.0
      	seat_hash[:percent] = free_seat_percentage.round

      	# logger.info '#######################'
      	# logger.info free_seat_percentage

      	seat_percentage = seat_hash.to_json


        response.stream.write "data: #{seat_percentage}\n\n"
        # logger.info "Processing the request..."
        # logger.info status

        start = Time.zone.now-5
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
