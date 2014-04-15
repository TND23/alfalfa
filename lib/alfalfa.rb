require_relative "alfalfa/sort/gem.rb"

class Alfalfa

	PWD_ARR = Dir.entries(Dir.pwd)


	def self.is_gemfile?
		# User may call this to see if the Gemfile is visible.
		puts Alfalfa::PWD_ARR.include?("Gemfile")
	end

	def self.sort_gemfile
		# If the current directory has a Gemfile, set its contents to file and call partition.
		if Alfalfa::PWD_ARR.include?("Gemfile")
			file = File.read("Gemfile")
			File.open("Gemfile")
			Alfalfa::Gem.partition_file(file)
		else
			puts "No Gemfile found!"
		end
	end

	
end