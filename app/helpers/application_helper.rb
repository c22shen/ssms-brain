module ApplicationHelper
def user_is_admin?
  if  user_signed_in?
  	if current_user.email == 'admin@ssmsgroup.ca'
  		return true
  	end 
  end
  return false
end

def getFloorBtnClass(id)

	result = ["btn", "btn-info", "btn-sm", "floor"+id.to_s+"-btn"]
	return result 
end

def getFloorBtnText(id)
	result = "Floor "+id.to_s+" Details"
	return result
end

def getFloorName(id)
	result ="Floor "+id.to_words.capitalize
	return result
end
# def personalizeContainer(original,suffix)
# 	return original+suffix
# end



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
