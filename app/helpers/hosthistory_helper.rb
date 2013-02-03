module HosthistoryHelper
	def timeDiffToStr(seconds)
		s = seconds % 60
		m = seconds / (60) %60
		h = seconds / (60*60) % (60*60)
		d = seconds / (24*60*60) % (24*60*60)

		return "%02d:%02d:%02d:%02d" % [d,h,m,s]
	end
end
