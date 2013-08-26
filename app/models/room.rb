class Room < ActiveRecord::Base

	before_save :set_name

	validates :name, :presence => true

	def to_param
		name
	end

	protected

  def set_name
  	# If defined then name it, if not generate a random string
    self.name ||= SecureRandom.urlsafe_base64(8)
  end
end
