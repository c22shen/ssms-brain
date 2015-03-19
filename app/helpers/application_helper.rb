module ApplicationHelper
def user_is_admin?
  if  user_signed_in?
  	if current_user.email == 'admin@ssmsgroup.ca'
  		return true
  	end 
  end
  return false
end

def getFloorChartBtnId(id)
	return "floorChart"+id.to_s+"Btn"
end

def getFloorBtnText(id)
	result = "Floor "+id.to_s
	return result
end

def getFloorName(id)
	result ="floor: " + id.to_s
	return result
end

def getEmptyMessage(library)
  library + ' ' + ENV['FREE_MSG']
end

def getFullMessage(library)
  library + ' ' + ENV['BUSY_MSG']
end

# def is_it_today?(date)
#   return (date.in_time_zone("Eastern Time (US & Canada)").month == Time.now.in_time_zone("Eastern Time (US & Canada)").month && date.in_time_zone("Eastern Time (US & Canada)").day == Time.now.in_time_zone("Eastern Time (US & Canada)").day)
# end

def date_display(date)
  time_eastern = date.in_time_zone("Eastern Time (US & Canada)")
  now_eastern = Time.now.in_time_zone("Eastern Time (US & Canada)")
  if ((time_eastern.month == now_eastern.month) && (time_eastern.day == now_eastern.day))
    hour_diff = (now_eastern.hour - time_eastern.hour) 
    if (now_eastern.to_i- time_eastern.to_i )<3600
      min_diff = ( now_eastern.to_i - time_eastern.to_i)/60
      return min_diff.to_i.to_s + ' minutes ago'
    else
      return hour_diff.to_s + ' hours ago'
    end
  else
    return time_eastern.strftime('%h %d')
  end
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
