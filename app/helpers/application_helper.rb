module ApplicationHelper
	def app_name
		"Rememorizer"
	end
	
	def sortable(column, title = nil)
		title ||= column.titleize
		css_class = column == sort_param ? "current #{direction_param}" : nil
		direction = column == sort_param && direction_param == "asc" ? "desc" : "asc"
		link_to title, {direction: direction, sort: column}, {class: css_class}
	end

	def link_to_add_fields(name, f, association)  
		new_object = f.object.class.reflect_on_association(association).klass.new  
		fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
			render(association.to_s.singularize + "_fields", :f => builder)  
		end  
		link_to name, "#/", 
		onclick: h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), 
		role: :button
	end
end
