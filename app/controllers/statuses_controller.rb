class StatusesController < ApplicationController
	def create 
		@status = Status.new(status_params)

		if @status.save
	      render json: @status, status: :created
	    else
	      render json: @status.errors, status: :unprocessable_entity
	    end
  	end

  	private
  	def status_params
      params.permit(:uid, :status)
    end
end
