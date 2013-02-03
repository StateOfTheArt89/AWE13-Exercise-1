class LogEntry < ActiveRecord::Base
  attr_accessible :ip, :mac, :went_off, :went_on

  def self.updateRecords
  	#Alle als derzeit online bekannten Einträge sammeln
  	currentlyOnlineEntries = LogEntry.where(:went_off => nil).all

  	#TODO In Konfiguration auslagern
	nmapOut = IO.popen('nmap 192.168.1.1/24 -sP')
	nmapOut.each do |nmapLine|
		if nmapLine.match(/Nmap scan report.+?/)
				nmapLine = nmapLine.sub(/Nmap scan report for /,'')
				nmapLine = nmapLine.sub(/\n/m,'')
				puts "Node online with ip address " + nmapLine

				#Versuch Mac-Adresse zu ermitteln
				macAddress = searchForMac(nmapLine)
				if macAddress == nil
					#Skip
					next
				end

				#Schauen, ob Mac-Adresse als Host bereits bekannt ist
				hostEntry = Host.where(:mac => macAddress).first
				if hostEntry == nil
					newHostEntry = Host.new
					newHostEntry.mac = macAddress
					newHostEntry.name = "?"
					newHostEntry.owner = "?"
					newHostEntry.save
				end

				entry = LogEntry.where(:mac => macAddress, :went_off => nil).first
				if entry == nil
					#Node wurde als neu online erkannt
					newEntry = LogEntry.new
					newEntry.mac = macAddress
					newEntry.went_on = DateTime.now
					newEntry.ip = nmapLine
					newEntry.save
					puts "Found new node online: " + nmapLine + " " + macAddress
					next
				end

				#Mac Adresse ist als derzeit online bekannt
				#Nach und nach alle online Hosts entfernen
				#Einträge, die nach dieser Schleife weiterhin im Array sind, sind von online auf offline gewechselt
				onlineEntry = currentlyOnlineEntries.find_all{|e| e.mac == macAddress}[0]
				if onlineEntry == nil:
					puts "Debug: Dieser Fall sollte nicht eintreten"
					next
				end
				currentlyOnlineEntries.delete(onlineEntry)
			end
		end

		puts currentlyOnlineEntries.count.to_s + " went offline"
		currentlyOnlineEntries.each do |entry|
			entry.went_off = DateTime.now
			entry.save
		end

	end

	def self.searchForMac(ipAddress)
		arpOut = IO.popen('arp ' + ipAddress)
		arpOut.each do |arpLine|
			if arpLine.match(/.+?(?:[A-Fa-f0-9]{2}[:-]){5}(?:[A-Fa-f0-9]{2}).+?/)
				result = arpLine.match(/(?:[A-Fa-f0-9]{2}[:-]){5}(?:[A-Fa-f0-9]{2})/)[0]
				puts "Found mac address " + result
				return result
			end
		end
		puts "Couldn't resolve mac for " + ipAddress
	end

end
