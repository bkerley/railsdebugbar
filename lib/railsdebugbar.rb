class RailsDebugBar
	def self.filter(controller)
		content_type = controller.response.content_type
		return unless content_type =~ /html/
		
		body = controller.response.body
		
		insertpoint = (body =~ /<\/body>/)
		if insertpoint.nil?
			insertpoint = -1
		end
		
		parts = ["DEBUG",
			rails_version
		]
		
		
		
		controller.response.body = body.insert(insertpoint, decorate_parts(parts))
	end
	
	def self.rails_version
		"Rails: "+Rails::VERSION::STRING
	end
	
	def self.decorate_parts(parts)
		css_for_insertion = <<-EOF
		<style>
		ul#rails_debug_bar {
			list-style-type: none;
			margin-bottom: 0;
			margin-top: 1em;
			padding-left: 0
		}
		ul#rails_debug_bar li {
			display: inline;
			padding: 0.2em;
			border: 1px solid black;
			background-color: #fda;
			color: black;
		}
		</style>
		EOF
		parts_for_insertion = parts.map{|s| "<li>#{s}</li>"}
		html_for_insertion = "<ul id=\"rails_debug_bar\">#{parts_for_insertion}</ul>"
		return css_for_insertion + html_for_insertion
	end
end