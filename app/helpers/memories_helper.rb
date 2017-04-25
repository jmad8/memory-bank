module MemoriesHelper
	def make_text_dissolve(text)
		dissolvable_text = "<div id='dissolver'>"
		text_copy = text

		loop do
			index = text_copy.index(/[-\s—]/) || text_copy.length-1

			dissolvable_text << "<div class='word'>"
			word = text_copy[0..index-1]
			word.each_char do |c|
				if letter?(c) || numeric?(c)
					dissolvable_text << "<span class='letter'>" << c << "</span>"
				else
					dissolvable_text << "<span>" << c << "</span>"
				end
			end
			dissolvable_text << "</div>"
			dissolvable_text << text_copy[index]

			break if index == text_copy.length-1

			text_copy = text_copy[index+1..-1]
		end
		dissolvable_text << "</div>"
		dissolvable_text.html_safe
	end

	def letter?(char)
	  char =~ /[[:alpha:]]/
	end

	def numeric?(char)
	  char =~ /[[:digit:]]/
	end

	def get_query_string(other_params = nil)
		parameters = nil
		if params[:offset] != nil
			parameters = {offset: params[:offset]}
		elsif params[:folder] != nil
			parameters = {folder: params[:folder]}
		end

		if parameters != nil && other_params != nil
			return parameters.merge(other_params)
		elsif parameters != nil
			return parameters
		elsif other_params != nil
			return other_params
		end
	end
end
