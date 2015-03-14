class MessagesController < ApplicationController
	include ActionController::Live
	def create
		@message = Message.new(message_params)
		@message.save!
		# redirect_to 'welcome_url'
		render nothing: true
	end

def events
  # @user = User.find_by_email('admin@ssmsgroup.ca')
  # @option = @user.option




  response.headers["Content-Type"] = "text/event-stream"

  
  # initialize
  

  # ***************SIMULATION**************
    color = '#8DEB95'
    # generate random seat change 
    random_num = rand
    # if (0..0.1).include?(random_num)
    #   new_status ='away'
    #   color =  "#FFB03B"
    if (0..0.3).include?(random_num)
      color = "#8DEB95"
      new_status='free'
    else
      color = "#EF5E43"
      new_status='busy'


    end


    rand_uid = rand(99)

    seat = Seat.new
    seat.uid = rand_uid

    
    seat.status = color
    curr_seat = Seat.where("mode='sim'").where("uid=#{rand_uid}").last
    # logger.debug "*************************#{rand_uid}"
    unless curr_seat.nil?
      seat.x = curr_seat.x
      seat.y = curr_seat.y
      seat.z = curr_seat.z
      

      free_seat_count=Seat.where("mode='sim'").where("status='free'").count
      busy_seat_count=Seat.where("mode='sim'").where("status='busy'").count
      away_seat_count=Seat.where("mode='sim'").where("status='away'").count
      


      free_seat_percentage =free_seat_count.to_f/(free_seat_count+busy_seat_count+away_seat_count)*100.0
      seat_json = seat.to_json
      seat_hash = JSON.parse(seat_json)
      seat_hash[:percent] = free_seat_percentage.round
      seat_hash[:free_seat_count] = free_seat_count
      seat_hash[:busy_seat_count] = busy_seat_count
      seat_hash[:away_seat_count] = away_seat_count


      free_array = Array.new 
        free_array.push(free_seat_count)
        free_array.push(rand(10..40))

        busy_array = Array.new 
        busy_array.push(busy_seat_count)
        busy_array.push(rand(10..40))

        seat_hash[:free_array] = free_array
        seat_hash[:busy_array] = busy_array


      # seat_hash[:empty_seat_count] = free_seat_count
      
      # select = false
      # if curr_seat.status != new_status 
        select = true
      # end
      seat_hash[:select] = select
      seat_hash_json = seat_hash.to_json
      response.stream.write "data: #{seat_hash_json}\n\n"
      curr_seat.status=new_status
      curr_seat.save!
    end
  # else
    # live
    # logger.debug '*************LIVE********************'
    


    Status.uncached do
    start = Time.zone.now-5
    status = Status.where('created_at > ?', start).last
      # Perhaps each is overdue
      # REMOVE LATER
      if !status.nil?
      	seat = Seat.new

      	if status.status =='free'
    		  color = '#8DEB95'
    		elsif status.status == 'busy'
    			color = '#EF5E43'
    		else
    			color = "#FFB03B"
    		end


      	seat.status = color
      	seat.uid = status.uid
      	seat.x = Seat.find_by_uid(status.uid).x
      	seat.y = Seat.find_by_uid(status.uid).y
        seat.z = Seat.find_by_uid(status.uid).z

      	seat_json = seat.to_json

      	seat_hash = JSON.parse(seat_json)

       

      	# logger.info '#######################'
      	# logger.info free_seat_percentage
      #   select = false
      # if curr_seat.status != new_status 
      #   select = true
      # end
      seat_hash[:select] = true

      free_seat_count=Seat.where("mode='live'").where("status='free'").count
      busy_seat_count=Seat.where("mode='live'").where("status='busy'").count
      # away_seat_count=Seat.where("mode='live'").where("status='away'").count
      seat_hash[:free_seat_count] = free_seat_count
      seat_hash[:busy_seat_count] = busy_seat_count
      # seat_hash[:away_seat_count] = away_seat_count

      free_array = Array.new 
      free_array.push(free_seat_count)
      free_array.push(rand(10..40))

      busy_array = Array.new 
      busy_array.push(busy_seat_count)
      busy_array.push(rand(10..40))

      seat_hash[:free_array] = free_array
      seat_hash[:busy_array] = busy_array


      free_seat_percentage =free_seat_count.to_f/(free_seat_count+busy_seat_count)*100.0
      seat_hash[:percent] = free_seat_percentage.round

      seat_hash_json = seat_hash.to_json


        response.stream.write "data: #{seat_hash_json}\n\n"
        # logger.info "Processing the request..."
        # logger.info status

        # start = Time.zone.now-5
     end 

   # end
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
