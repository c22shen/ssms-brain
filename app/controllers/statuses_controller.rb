class StatusesController < ApplicationController
	def create 
		@status = Status.new(status_params)
        if params[:status][0]=='x'
# MAPPING STATUS
# EXAMPLE: x1:0.0,y1:0.0/x2:30.0,y2:40.0/x3:60.0,y3:0.0/x4:90.0,y4:40.00006/x5:120.0,y5:6.317126E-5/
        # logger.debug '*************LOCATION STATUS INFO'

        location_array = params[:status].split('/')

        location_array.each_with_index {|val, index| 
          location_info = val.split(',')
          x_val = location_info[0].split(':')[1]
          y_val = location_info[1].split(':')[1]
          seat = Seat.where("mode='live'").find_by_uid(index)
          unless seat.nil?
            seat.x = x_val
            seat.y = y_val
            seat.z = 1 
            # DEFAULT to FLOOR 1
             # logger.debug '*************X VAL **********'
             # logger.debug x_val
             # logger.debug '*************Y VAL **********'
             # logger.debug y_val

            seat.save!
          end}

        else
# MONITORING STATUS

        uid = params[:uid]
        seat = Seat.find_by_id(uid)
        seat.status = params[:status]

        seat.save!
      end

		if @status.save
	      render json: @status, status: :created
	    else
	      render json: @status.errors, status: :unprocessable_entity
	    end
  	end

  	def get_mode 
  		mode = User.find_by_email('admin@ssmsgroup.ca').mode
  		render json: mode, status: :ok
  	end

  	def mode_update
  		@user = User.find_by_email('admin@ssmsgroup.ca')
  		
  		if @user.mode  == 'map'
  			@user.mode = 'monitor'
  		else
  			@user.mode = 'map'
  		end
  		@user.save!
		respond_to do |format|
	      format.js {render :nothing => true, :status => 200, :content_type => 'text/html'}
	    end
  	end

    def seat_location_update
      @user = User.find_by_email('admin@ssmsgroup.ca')
      
      query_string = (@user.option  == 'live') ? "mode='live'" : "mode='sim'"
      # logger.debug "UID********************"
      # logger.debug params[:uid]

      # logger.debug "X********************"
      # logger.debug params[:x]
      
      # logger.debug "Y********************"
      # logger.debug params[:Y]
      
      seat = Seat.where(query_string).find_by_uid(params[:uid])
      seat.x = params[:new_x]
      seat.y = params[:new_y]
      seat.save!

    respond_to do |format|
        format.js {render :nothing => true, :status => 200, :content_type => 'text/html'}
      end
    end

    def option_update
      @user = User.find_by_email('admin@ssmsgroup.ca')
      
      if @user.option  == 'live'
        @user.option = 'sim'
      else
        @user.option = 'live'
      end
      @user.save!
    respond_to do |format|
        format.js {render :nothing => true, :status => 200, :content_type => 'text/html'}
      end
    end



  	private
  	def status_params
      params.permit(:uid, :status)
    end
end
