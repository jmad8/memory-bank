module FoldersHelper
    def get_folders(user_id, folder_id = nil)
    	folders = [["Home", nil]]
    	set_folders_recursive(folders, user_id, nil, folder_id, "&nbsp;&nbsp;")
    	return folders
    end

    def get_folder_treeview(user_id, selected_folder_id = nil)
    	counter = [0]
		folders = Folder.all.where({user_id: user_id, parent_folder_id: nil})
    	obj = {text: "Home", href: memories_path, selectable: false}
    	if (selected_folder_id == 0)
    		obj[:backColor] = "rgb(66, 139, 202)"
    		obj[:color] = "rgb(255, 255, 255)"
    		@nodeId = counter[0]
		end
    	nodes_json = []
    	if (folders.count > 0)
	    	folders.each do |folder|
	    		get_folder_treeview_recursive(nodes_json, user_id, folder, selected_folder_id, counter)
    		end
    	end
    	obj[:nodes] = nodes_json
	    return [obj]
    end

    private
		def set_folders_recursive(folders, user_id, parent_id, folder_id, prefix)
			children_folders = Folder.all.where({user_id: user_id, parent_folder_id: parent_id}).where.not(id: folder_id || -1)
			children_folders.each do |current|
				folders.push([(prefix + "-" + current.name).html_safe, current.id])
				set_folders_recursive(folders, user_id, current.id, folder_id, prefix + "&nbsp;&nbsp;&nbsp;")
			end
		end

	    def get_folder_treeview_recursive(json, user_id, folder, selected_folder_id, counter)
	    	counter[0] += 1
	    	obj = {text: folder.name, href: memories_path(folder: folder.id), selectable: false}
	    	if (folder.id == selected_folder_id)
	    		obj[:backColor] = "rgb(66, 139, 202)"
	    		obj[:color] = "rgb(255, 255, 255)"
	    		@nodeId = counter[0]
			end
	    	nodes_json = []
	    	if (folder.children_folders.count > 0)
	    		folder.children_folders.each do |child|
	    			get_folder_treeview_recursive(nodes_json, user_id, child, selected_folder_id, counter)
	    		end
	    	end
	    	obj[:nodes] = nodes_json
	    	json.push(obj)
	    end
end
