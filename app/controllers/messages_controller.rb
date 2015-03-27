include ActionView::Helpers::TextHelper

class MessagesController < ApplicationController
	include ActionController::Live
	def create
		@message = Message.new(message_params)
		@message.save!
		# redirect_to 'welcome_url'
		render nothing: true
	end

  def events
  # this is the messaging generator/reader 
  #2 ways to generate message 
  #1. generate random seat status change - for dp library 
  #2. read in status database change - for dc library 
    response.headers["Content-Type"] = "text/event-stream"
    
    new_id = 0
    new_status = String.new
    new_volume = 0 

    Status.uncached do
      status = Status.where('created_at > ?', Time.zone.now-5).last
      unless status.nil? 
        new_id = status.uid
        new_status=status.status
        new_volume = status.volume
      else
        random_num = rand
        if (0..0.3).include?(random_num)
          new_status='free'
        else
          new_status='busy'
        end
        new_volume = rand *300
        # DC library reserved for live 
        dc_library = Library.find(1)
        new_id = rand(dc_library.seats.maximum(:id)+1..Seat.maximum(:id))
      end
    end
    
    # logger.debug "*******************#{new_id}*************"
    # logger.debug "***************#{new_status}************************"
  # only two piece of info required: UID, STATUS

    curr_seat = Seat.find_by_id(new_id)

    # can't find the seat.
    unless curr_seat.nil?
      new_seat = Seat.new
      if new_status =='free'
        status_color = ENV['COLOR_FREE']
      elsif new_status == 'busy'
        status_color = ENV['COLOR_BUSY']
      end    

      if new_volume <100 
        volume_color = ENV['COLOR_FREE']
      elsif new_volume < 200
        volume_color = ENV['COLOR_MODERATE']
      else
        volume_color = ENV['COLOR_BUSY']        
      end    
      new_seat.status = new_status
      new_seat.volume = new_volume.round


      library = curr_seat.library
      new_seat.id = new_id
      new_seat.x = curr_seat.x
      new_seat.y = curr_seat.y
      new_seat.z = curr_seat.z
      new_seat.library_id = curr_seat.library_id

      # try to eliminate 
      free_seat_count=library.seats.where("status='free'").count
      busy_seat_count=library.seats.where("status='busy'").count
      free_seat_percentage =free_seat_count.to_f/(free_seat_count+busy_seat_count)*100.0
      

      new_seat_json = new_seat.to_json
      new_seat_hash = JSON.parse(new_seat_json)
      # Detail Section
      new_seat_hash[:status_color] = status_color
      new_seat_hash[:volume_color] = volume_color
      new_seat_hash[:free_seat_percentage] = free_seat_percentage.round
      new_seat_hash[:free_seat_count] = free_seat_count
      new_seat_hash[:busy_seat_count] = busy_seat_count

      new_seat_hash[:library_name] = curr_seat.library.name
      new_seat_hash[:freeSeatCountLabelName] = ENV['LABEL_FREE']+library.acronym
      new_seat_hash[:busySeatCountLabelName] = ENV['LABEL_BUSY']+library.acronym
      new_seat_hash[:freeSeatPercentChartName] = ENV['CHART_PERCENT']+library.acronym
      new_seat_hash[:occupancyMsgContainerName] = ENV['CONTAINER_OCCUPANCY_MSG']+library.acronym
            
      # bar chart info
      free_seat_data_array = Array.new 
      busy_seat_data_array = Array.new 
      
      Library.all.each do |library|
        unless library.seats.empty?
          free_seat_data_array.push(library.seats.where("status='free'").count)
          busy_seat_data_array.push(library.seats.where("status='busy'").count)
        end
      end

      new_seat_hash[:free_seat_data_array] = free_seat_data_array
      new_seat_hash[:busy_seat_data_array] = busy_seat_data_array

      #containerNames
      new_seat_hash[:splineChartContainerName] = ENV['CONTAINER_SPLINE']+library.acronym
      new_seat_hash[:d3ChartContainerName] = ENV['CONTAINER_3D']+library.acronym
      new_seat_hash[:barChartContainerName] = ENV['CONTAINER_BAR']
      new_seat_hash[:floorChartContainerName] = ENV['CONTAINER_FLOOR']+library.acronym
      new_seat_hash[:volumeChartContainerName] = ENV['CONTAINER_VOLUME']+library.acronym
      
      # percentDisplayName #numberOfFreeSeats
      new_seat_hash[:percentDisplayName] = ENV['PERCENT_DISPLAY']+library.acronym
      new_seat_hash[:percentDisplayValue] = pluralize(free_seat_count, 'seat') + ' available'
      

      # send data to javascript
      new_seat_hash_json = new_seat_hash.to_json
      response.stream.write "data: #{new_seat_hash_json}\n\n"
      # update seat data
      curr_seat.volume = new_volume.round
      curr_seat.status = new_status
      curr_seat.save!
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
