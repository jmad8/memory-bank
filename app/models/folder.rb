class Folder < ActiveRecord::Base
	validates :name,  presence: true

	belongs_to :user
	belongs_to :parent_folder, class_name: "Folder"
	has_many :children_folders, class_name: "Folder", foreign_key: "parent_folder_id"
	has_many :memories

	before_destroy :update_memories
	attr_accessor :path

	def update_memories
		self.memories.update_all(folder_id: self.parent_folder_id)
		self.children_folders.update_all(parent_folder_id: self.parent_folder_id)
	end

	def get_path
		return self.path unless self.path == nil

		self.path = []
		current = self
		while (current != nil)
			self.path.insert(0, current)
			current = current.parent_folder
		end
		self.path
	end

	def all_memories
		memories = self.memories
		children_folders.each do |child|
			# memories << child.all_memories
		end
	end
end
