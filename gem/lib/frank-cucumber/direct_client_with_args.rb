require 'sim_launcher'

module SimLauncher
	class DirectClientWithArgs < DirectClient
		def initialize( app_path, sdk, family, args )
			@app_path = File.expand_path( app_path )
			@sdk = sdk
			@family = family
			@args = args
		end

		def launch
			SimLauncher::Simulator.new.launch_ios_app( @app_path, @sdk, @family, @args ) 
		end

		def relaunch
			simulator = SimLauncher::Simulator.new
			simulator.quit_simulator
			simulator.launch_ios_app( @app_path, @sdk, @family, @args )
		end
	end
end
