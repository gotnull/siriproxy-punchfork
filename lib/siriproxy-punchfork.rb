require 'cora'
require 'siri_objects'
require 'json'
require 'httparty'
	
class SiriProxy::Plugin::PunchFork < SiriProxy::Plugin

	class Recipe

		def initialize(title, thumb)
			# Instance variables
			@title = title
			@thumb = thumb
		end
		
		def show_title
			return @title
		end

		def show_thumb
			return @thumb
		end

	end  
	
	def initialize(config = {})
		apikey = "690d6c63c08a79"
		@uri = "http://api.punchfork.com/random_recipe?key=#{apikey}"
		@responses_wait = ["One moment.", "Your wish is my command.", "Yes, my master.", "Please hold.", "Just a second.", "Just chill.", "Hang on a second.", "Hold on a second.", "Just a moment.", "Give me a second."]
		@responses = [  "Why don't you cook some",
						"Go to the supermarket and cook some",
						"You have cool dreadlocks, but why don't you cook some",
						"That's easy, just cook some"
		]
	end

	def random_recipe

		page = HTTParty.get(@uri).body rescue nil
		show_info = JSON.parse(page) rescue nil

		#puts recipe

		recipe = nil
		
		unless show_info.nil?
			if (show_info['error'])
				recipe_title = "How the fuck should I know?"
			else
				recipe_title = "#{@responses[rand(@responses.size)]} #{show_info['recipe']['title']}."
				recipe_thumb = show_info['recipe']['thumb']
			end
			
			recipe = Recipe.new(recipe_title, recipe_thumb)
		end
		
		return recipe

	end

	# Example: "Siri, what's for dinner?", "Siri, what's to eat?"
	listen_for /(for|to|the) (dinner|eat)/i do |item|

		say @responses_wait[rand(@responses_wait.size)]

		Thread.new {
		
			say "#{random_recipe.show_title}"
		
			object = SiriAddViews.new

			object.make_root(last_ref_id)

			answer = SiriAnswer.new("Image:", [
				SiriAnswerLine.new("logo", "#{random_recipe.show_thumb}")
			])

			object.views << SiriAnswerSnippet.new([answer])

			send_object object
				
			request_completed
		}

	end

end
