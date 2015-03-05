class StatusesController < ApplicationController
	def create 
		@status = Status.new(status_params)

        uid = params[:uid]
        seat = Seat.find_by_uid(uid)
        seat.status = params[:status]
        seat.save!

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



  	private
  	def status_params
      params.permit(:uid, :status)
    end
end
