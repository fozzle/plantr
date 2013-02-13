class API < Grape::API
	prefix "api"
	format :json

	helpers do
	 #  def current_user
	 #    warden.user
	 #  end

	 #  def authenticated
		#   if warden.authenticated?
		#     return true
		#   else
		#     error!('401 Unauthorized', 401)
		#   end
		# end
  end

  # resource "auth" do
  # 	desc "Login user"
  # 	params do
  # 		group :user do
	 #  		requires :email, type: String, desc: "User email"
	 #  		requires :password, type: String, desc: "password"
	 #  	end
  # 	end
  # 	post do
  # 		user = User.find_by_email(params[:user][:email])
  # 		if user.password == params[:user][:password]
  # 			current_user = user
  # 		else
  # 			throw :error, status: 401, message: "Invalid login!"
  # 		end
  # 	end
  # end


	
	resource "users" do

		desc "Retrieve all users"
		get do
			User.all
		end

		desc "Retrieve specific user"
		get ':id' do
			User.find(params[:id])
		end

		desc "Create a user."
		params do
			group :user do
				requires :email, type: String, desc: "email address."
				requires :password, type: String, desc: "password"
			end
		end
		post do
			user = User.new(params[:user])
			user.save
		end

		# desc "Return the user's garden"
		# params do
		# 	requires :user_id, :type => Integer, :desc => "User id"
		# end
		# get :user_gardens do
		# 	Garden.where(user: params[:user_id])
		# end

	end

	resource "gardens" do

		desc "Retrieve user's gardens"
		get do
			User.first.gardens
		end

		desc "Create a garden"
		params do
			requires :name, type: String, desc: "Name of the garden"
		end
		post do
			garden = Garden.new(params)
			if current_user.gardens.where(name: params[:name]).any?
				throw :error, status: 400, message: "You already have that"
			else
				garden.save
			end
		end

		desc "List plants in garden"
		get ':id/plants' do
			garden = Garden.find(params[:id])
			Plants.where(garden: garden)
		end

	end

	resource "plants" do

		desc "Create a plant"
		params do
			requires :name, type: String, desc:"Name of plant"
		end
		

end