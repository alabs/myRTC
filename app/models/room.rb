class Room < ActiveRecord::Base

	before_save :set_name

	validates :name, presence: true
	validates :name, uniqueness: true
	validates :name, length: {
      minimum: 3,
      maximum: 100,
    }

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
