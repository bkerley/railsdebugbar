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
			rails_version,
			"#{controller.class.to_s}/#{controller.action_name}.#{controller.request.format}",
			controller.response.status,
			["Request headers"] + hash_to_array(controller.request.headers),
			["Response headers"]+ hash_to_array(controller.response.headers)
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
			display: inline-block;
			padding: 0.2em;
			border: 1px solid black;
			background-color: #fda;
			color: black;
		}
		ul#rails_debug_bar li ul {
			display: none;
			padding-left: 0px;
		}
		ul#rails_debug_bar li:hover ul {
			display: block;
			position: absolute;
			z-index: 2;
		}
		ul#rails_debug_bar li ul li {
			display: block;
		}
		</style>
		EOF
		parts_for_insertion = array_to_li(parts)
		html_for_insertion = "<ul id=\"rails_debug_bar\">#{parts_for_insertion}</ul>"
		return css_for_insertion + html_for_insertion
	end
	
	private
	def self.array_to_li(array)
		array.map do |s|
			if s.is_a? Array
				"<li>#{CGI::escapeHTML s.first}<ul>#{array_to_li(s[1..-1])}</ul></li>"
			else
				"<li>#{CGI::escapeHTML s}</li>"
			end
		end
	end
	
	def self.hash_to_array(hash)
		hash.map do |k,v|
			"#{k}: #{v}"
		end
	end
end