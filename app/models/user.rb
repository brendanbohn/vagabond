class User < ActiveRecord::Base
	#allowing users to have posts
	has_many :posts
	# allow easy authentication
	has_secure_password
	# for paperclip
	has_attached_file :profile_pic, styles: { large: "1000x1000>", medium: "200X200#", thumb: "100x100>" }, default_url: "missing.png"
  validates_attachment_content_type :profile_pic, content_type: /\Aimage\/.*\Z/

	BCrypt::Engine.cost = 12
	validates :email, presence: true
	validates :password_digest, presence: true
	validates_confirmation_of :password

	extend FriendlyId
	friendly_id :username, use: :slugged

	def password
		@password
	end

	def password=(unencrypted_password)

		@password = unencrypted_password

		self.password_digest = BCrypt::Password.create(@password)
	end

	def authenticate(unencrypted_password)
		secure_password = BCrypt::Password.new(self.password_digest)

		if secure_password == unencrypted_password
			self
		else
			#password incorrect return false
			false
		end
	end

	def self.confirm(email_param, password_param)
		#look up user by the email that was passed into this method
		user = User.find_by_email(email_param)
		# check that user's password matches the stored password_digest
		user.authenticate(password_param)
	end



end
