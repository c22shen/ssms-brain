class MessagesController < ApplicationController
	include ActionController::Live
	def create
		@message = Message.new(message_params)
		@message.save!
		# redirect_to 'welcome_url'
		render nothing: true
	end

def events
  @user = User.find_by_email('admin@ssmsgroup.ca')
  @option = @user.option




  response.headers["Content-Type"] = "text/event-stream"

  
  # initialize
  if @option == 'sim'
    color = '#00FF00'
    # generate random seat change 
    random_num = rand
    if (0..0.2).include?(random_num)
      new_status ='away'
      color =  "#4682B4"
    elsif (0.2..0.6).include?(random_num)
      color = "#00FF00"
      new_status='free'
    else
      color = "#DC143C"
      new_status='busy'


    end


    rand_uid = rand(49)

    seat = Seat.new
    seat.uid = rand_uid

    
    seat.status = color
    curr_seat = Seat.where("mode='sim'").where("uid=#{rand_uid}").last
    seat.x = curr_seat.x
    seat.y = curr_seat.y
    

    free_seat_count=Seat.where("mode='sim'").where("status='free'").count
    free_seat_percentage =free_seat_count.to_f/Seat.where("mode='sim'").count*100.0
    seat_json = seat.to_json
    seat_hash = JSON.parse(seat_json)
    seat_hash[:percent] = free_seat_percentage.round
    # seat_hash[:empty_seat_count] = free_seat_count
    
    select = false
    if curr_seat.status != new_status 
      select = true
    end
    seat_hash[:select] = select
    seat_hash_json = seat_hash.to_json
    response.stream.write "data: #{seat_hash_json}\n\n"
    curr_seat.status=new_status
    curr_seat.save!
  else
    # live
    logger.debug '*************LIVE********************'
    


    Status.uncached do
    start = Time.zone.now-5
    status = Status.where('created_at > ?', start).last
      # Perhaps each is overdue
      # REMOVE LATER
      if !status.nil?
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

        free_seat_count=Seat.where("mode!='sim'").where("status='free'").count



      	free_seat_percentage =free_seat_count.to_f/Seat.where("mode!='sim'").count*100.0
      	seat_hash[:percent] = free_seat_percentage.round

      	# logger.info '#######################'
      	# logger.info free_seat_percentage
      #   select = false
      # if curr_seat.status != new_status 
      #   select = true
      # end
      seat_hash[:select] = true
      seat_hash_json = seat_hash.to_json


        response.stream.write "data: #{seat_hash_json}\n\n"
        # logger.info "Processing the request..."
        # logger.info status

        start = Time.zone.now-5
     end 
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
