class RailsDebugBar
	def self.filter(controller)
		content_type = controller.response.content_type
		return unless content_type =~ /html/
		
		body = controller.response.body
		
		insertpoint = (body =~ /<\/body>/)
		if insertpoint.nil?
			insertpoint = -1
		end
		
		bar = "DEBUG"
		controller.response.body = body.insert(insertpoint, bar)
	end
end