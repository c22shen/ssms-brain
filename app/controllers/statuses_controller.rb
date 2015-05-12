class StatusesController < ApplicationController
	def create 
		@status = Status.new(status_params)
    # LOCATION STATUS
        if params[:status][0]=='x'
          location_array = params[:status].split('/')
          location_array.each_with_index {|val, index| 
            location_info = val.split(',')
            x_val = location_info[0].split(':')[1]
            y_val = location_info[1].split(':')[1]
            seat = Library.first.seats.find_by_id(index)
            unless seat.nil?
              seat.x = x_val
              seat.y = y_val
              seat.z = 1 
              seat.save!
            end}

        else
# MONITORING STATUS
        id = params[:uid]
        seat = Seat.find_by_id(id)
        seat.status = params[:status]
        seat.volume = params[:volume]
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
      
      seat = Library.first.seats.find_by_id(params[:id])
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

    def current_sensor 
      seat = Library.find_by_name('machine shop').seats.first
      seat.status = params[:status]
      seat.save!
      respond_to do |format|
        format.js {render :nothing => true, :status => 200, :content_type => 'text/html'}
      end
    end 



  	private
  	def status_params
      params.permit(:uid, :status, :volume)
    end
end
