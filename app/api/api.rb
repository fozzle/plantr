class API < Grape::API

	prefix "api"
	format :json

	helpers do
    def current_user
      warden.user
    end

    def authenticated
		  if warden.authenticated?
		    return true
		  else
		    error!('401 Unauthorized', 401)
		  end
		end
  end
	
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
			requires :username, type: String, desc: "Unique username."
			requires :email, type: String, desc: "email address."
			requires :password, type: String, desc: "password"
			requires :first_name, type: String, desc: "First name."
			requires :last_name, type: String, desc: "Last name."
		end
		post do
			user = User.new(params)
			if User.where(email: params[:email]).any?
				throw :error, status: 400, message: "Username taken!"
			else
				user.save
			end
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
			current_user.gardens
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

end