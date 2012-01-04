require 'cora'
require 'siri_objects'
require 'json'
require 'httparty'

class SiriProxy::Plugin::PunchFork < SiriProxy::Plugin

	def initialize(config = {})
		apikey = "1234567890"
		@uri = "http://api.punchfork.com/random_recipe?key=#{apikey}"
		@responses = [  "Why don't you cook some fucking",
				"Go to the supermarket and cook some fucking",
				"You have cool dreadlocks, but why don't you cook some fucking",
				"That's easy, just cook some fucking"
		]
	end

	def random_recipe

		page = HTTParty.get(@uri).body rescue nil
		recipe = JSON.parse(page) rescue nil

		#puts recipe

		r = ""
		
		unless recipe.nil?
			if (recipe['error'])
				r = "How the fuck should I know?"
			else
				r = "#{@responses[rand(@responses.size)]} #{recipe['recipe']['title']}."
			end
		end
		
		return r

	end

	# Example: "Siri, what's for dinner?", "Siri, what's to eat?"
	listen_for /(for|to) (dinner|eat)/i do |item|

		say "What's for dinner?"

		Thread.new {
		
			say "#{random_recipe}"
		
			request_completed
		}

	end

end
