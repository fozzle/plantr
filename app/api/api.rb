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

		desc "Destroy user"
		delete ":id" do
			user = User.find(params[:id])
			user.destroy
		end

	end

	resource "gardens" do

		desc "Retrieve user's gardens"
		get do
			User.first.gardens
		end

		desc "Create a garden"
		params do
			group :garden do
				requires :name, type: String, desc: "Name of the garden"
			end
		end
		post do
			garden = Garden.new(params[:garden])
			if User.first.gardens.where(name: params[:name]).any?
				throw :error, status: 400, message: "You already have that"
			else
				garden.save
			end
		end

		desc "List plants in garden"
		get ':id/plants' do
			garden = Garden.find(params[:id])
			Plant.where(garden_id: garden)
		end

		desc "Add user to garden"
		params do
			group :garden do
				requires :garden_id, type: Integer, desc: "Garden ID"
				requires :user_id, type: Integer, desc: "User ID"
			end
		end
		put 'add_user' do
			garden = Garden.find(params[:garden][:garden_id])
			garden.users << User.find(params[:garden][:user_id])
			garden.save
		end

		desc "Destroy garden"
		delete ":id" do
			garden = Garden.find(params[:id])
			garden.destroy
		end

	end

	resource "plants" do

		desc "Create a plant"
		params do
			group :plant do
				requires :name, type: String, desc:"Name of plant"
				requires :plant_type_id, type: Integer, desc:"Plant type"
				requires :sensor_id, type: Integer, desc:"Sensor ID"
				requires :garden_id, type: Integer, desc:"Garden ID"
			end
		end
		post do
			plant = Plant.new(params[:plant])
			plant.save
		end

		desc "Retrieve sensor logs"
		get ":id/logs" do
			plant = Plant.find(params[:id])
			plant.sensor.logs
		end

		desc "Destroy plant"
		delete ":id" do
			plant = Plant.find(params[:id])
			plant.destroy
		end
	end

	resource "sensors" do

		desc "Create a sensor"
		params do
			group :sensor do
				requires :name, type: String, desc: "Name of sensor"
				requires :description, type: String, desc: "Blurb about sensor"
			end
		end
		post do
			sensor = Sensor.new(params[:sensor])
			sensor.save
		end
	end

	resource "logs" do
		desc "Create new log"
		params do
			group :log do
				requires :sensor_id, type:Integer, desc: "Sensor id"
				requires :sunlight, type: Integer, desc: "Sunlight reading"
				requires :moisture, type: Integer, desc: "Moisture reading"
				requires :temperature, type: Integer, desc: "Temp reading (F)"
			end
		end
		post do
			log = Log.new(params[:log])
			log.save
		end
	end
end