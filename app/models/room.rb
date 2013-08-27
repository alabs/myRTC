class Room < ActiveRecord::Base

	before_save :set_name

	validates :name, :presence => true

  scope :public, -> { where(password: nil) }

	def to_param
		name
	end

    def check_password? given_password
      password? && ( given_password == password )
    end

	protected

  def set_name
  	# If defined then name it, if not generate a random string
    self.name ||= SecureRandom.urlsafe_base64(8)
  end
    
end
