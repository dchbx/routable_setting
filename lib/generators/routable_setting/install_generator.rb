require 'rails/generators/base'
module RoutableSetting::Generators
	class InstallGenerator < Rails::Generators::Base
		desc "Create a MongoDB collection <my_application>_routable_settings to store local settings"

		def create_mdb_collection
			## Code to create collection here

		end

	end
end