class Room < ActiveRecord::Base

	before_save :set_name

	def to_param
		name
	end

	protected

  def set_name
    self.name = SecureRandom.urlsafe_base64(8)
  end
end
