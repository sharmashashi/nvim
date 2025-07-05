flutter_device_id = nil;
flavor = nil


return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")

		dap.adapters.flutter = {
			type = "executable",
			command = "flutter",
			args = { "debug_adapter" },
		}
		dap.configurations.dart = {
			{
				type = "flutter",
				request = "launch",
				name = "Launch Flutter Program",
				-- The nvim-dap plugin populates this variable with the filename of the current buffer
				--program = "${file}",
				-- The nvim-dap plugin populates this variable with the editor's current working directory
				cwd = "${workspaceFolder}",
				program = "${workspaceFolder}/lib/main.dart",

				-- This gets forwarded to the Flutter CLI tool, substitute `linux` for whatever device you wish to launch
				--toolArgs = {"-d", "macos"}
				toolArgs = function()
					if flavor then
						return { "-d", flutter_device_id, "--flavor", flavor }
					else
						return { "-d", flutter_device_id, }
					end
				end
			},
		}

		function start_dap()
			vim.ui.input(
				{ prompt = "Enter flavor. Hit enter to continue without flavor" },
				function(input)
					if input == '' then
						flavor = nil;
					else
						flavor = input
					end
				end
			)
			if (flutter_device_id) then
				vim.ui.input(
					{
						prompt = "Continue with last selected device: " ..
						    flutter_device_id .. "? (Y/N): "
					},
					function(input)
						if input and (input:lower() == "y" or input:lower() == "yes" or input == "") then
							dap.continue()
							vim.defer_fn(ignore_breakpoints, 2000) -- Executes ignore_breakpoints after 2 seconds
						else
							run_dap()
						end
					end
				)
			else
				run_dap()
			end
		end

		function run_dap()
			show_flutter_devices(nil, function(device_id)
				if device_id then
					flutter_device_id = device_id
					dap.continue()
					vim.defer_fn(ignore_breakpoints, 2000) -- Executes ignore_breakpoints after 2 seconds
				else
					print("No device selected. Debugging aborted.")
				end
			end)
		end

		function ignore_breakpoints()
			dap.set_exception_breakpoints({})
		end
	end,
}
