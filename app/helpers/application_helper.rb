module ApplicationHelper
def user_is_admin?
  if  user_signed_in?
  	if current_user.email == 'admin@ssmsgroup.ca'
  		return true
  	end 
  end
  return false
end
end
