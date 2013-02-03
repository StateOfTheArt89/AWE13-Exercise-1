
class Host < ActiveRecord::Base
  attr_accessible :mac, :name, :owner

  def is_online
  	entryCount = LogEntry.where(:mac => mac,:went_off => nil).count
  	return entryCount == 0
  end

  def get_log_entries
  	entries = LogEntry.where(:mac => mac).all
  	return entries
  end

  def total_uptime
  	entries = LogEntry.where(:mac => mac).all
  	uptime = 0
  	entries.each do |entry|
  		if entry.went_off == nil:
  			uptime += DateTime.now - entry.went_on
  		else
  			uptime += entry.went_off - entry.went_on
  		end
  	end

  	return uptime
  end

  def uptime
  	entry = LogEntry.where(:mac => mac, :went_off => nil).first
  	uptime = 0
	if entry != nil:
		uptime += entry.went_off - entry.went_on
	end
  	return uptime
  end

end
