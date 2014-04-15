module Alfalfa
	PWD_ARR = Dir.entries(Dir.pwd)

	module_function
	def self.is_gemfile?
		# User may call this to see if the Gemfile is visible.
		puts Alfalfa::PWD_ARR.include?("Gemfile")
	end

	def self.sort_gemfile
		# If the current directory has a Gemfile, set its contents to file and call partition.
		if Alfalfa::PWD_ARR.include?("Gemfile")
			file = File.read("Gemfile")
			File.open("Gemfile")
			partition_file(file)
		else
			puts "No Gemfile found!"
		end
	end

	def rewrite_gemfile(sg,sng,ss)
		#Open a writable version of the Gemfile, and add modified contents.
		File.open("Gemfile", 'w') do |f|
			f.puts ss
			f.puts "\n"
			f.puts sng
			f.puts "\n"
			f.puts sg
		end
	end

	def partition_file(file)
		# Call segment methods on each part of the Gemfile, then rewrite it.
		sg = segment_groups(file)
		sng = segment_non_groups(file)
		ss = segment_source(file)
		rewrite_gemfile(sg,sng,ss)			
	end

	def segment_groups(file)
		# groups will be an array containing n sub-arrays, where n is the number of groups in the Gemfile.
		# Each sub-array will be filled with one group, starting with a 'group do' clause, and ending with 'end'.
		groups = file.to_enum(:scan, /(^(group).{0,}(do)$)(\n(.+)){0,}\nend/).map{ Regexp.last_match(0) }
		ordered_groups = []
		segmented_groups = []

		for i in 0...groups.length
			segmented_groups[i] = groups[i].split("\n")
		end

		for i in 0...segmented_groups.length
			# Cut out the 'group do' and the 'end' from each sub-array, so only gems remain.
		  ordered_groups[i] = segmented_groups[i][1,segmented_groups[i].length-2]
		  ordered_groups[i].sort!
		  # Add the 'group do' and 'end' back in, as well as a blank line.
		  ordered_groups[i].unshift(segmented_groups[i][0])
		  ordered_groups[i].push(segmented_groups[i].last)
		  ordered_groups[i].push("\n")
		end
		return ordered_groups
	end

	def segment_non_groups(file)
		# non_groups will be defined as everything that was not captured when matching for groups.
		non_groups = file.to_enum(:scan, /^((?!(^(group|\t|\s|end|Source).{0,})(\n(.*)){0,}\n).)*$/).map{ Regexp.last_match(0) }
		sort_segmented_non_groups(non_groups)
	end

	def segment_source(file)
		# The Source https://rubygems... line
		source_group = file.match(/^Source.{0,}/i)
	end

	def sort_segmented_groups(segmented_groups)
		ordered_groups = []
		segmented_groups.each do |segmented_group|
			temp_arr = segmented_group[1,segmented_group.length-2]
			temp_arr.sort!
			sorted << segmented_group[0].split + temp_arr + segmented_group.last.split
		end
		return sorted
	end

	def sort_segmented_non_groups(non_groups)
		non_groups.sort!
		# Remove duplicates caused by empty spaces.
		non_groups.uniq!
		# The Gemfiles final 'end' will be captured, as will the source http... line
		non_groups.keep_if{ |el| el != "" && el != "end" && !el.downcase.include?("source")}
		return non_groups
	end
end