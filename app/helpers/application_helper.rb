module ApplicationHelper
def user_is_admin?
  if  user_signed_in?
  	if current_user.email == 'admin@ssmsgroup.ca'
  		return true
  	end 
  end
  return false
end

# def status_to_color(status)
# 	if status =='free'
# 		color = '#00FF00'
# 	elsif status == 'busy'
# 		color = 'DC143C'
# 	else
# 		color = "4682B4"
# 	end
# 	return color	
# end

end
