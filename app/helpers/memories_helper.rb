module MemoriesHelper
	def make_text_dissolve(text)
		dissolvable_text = "<div id='dissolver'>"
		text.split(" ").each do |word|
			dissolvable_text << "<div class='word'>"
			word.each_char do |c|
				if letter?(c) || numeric?(c)
					dissolvable_text << "<span class='letter'>" << c << "</span>"
				else
					dissolvable_text << "<span>" << c << "</span>"
				end
			end
			dissolvable_text << "</div> "
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
			return parameters || other_params
		end
	end
end
