-- flutter_tools.lua

-- Function to get a list of available Flutter devices
function get_flutter_devices()
	local devices_list = run_shell_command("flutter devices")
	local devices = {}

	for line in devices_list:gmatch("[^\r\n]+") do
		-- Match lines with the structure: <name> • <id> • <type>
		local name, id, type = line:match("([^•]+)•%s*([^•]+)•%s*([^•]+)")
		if name and id and type then
			-- Trim and clean up the matched fields
			table.insert(devices, {
				name = name:match("^%s*(.-)%s*$"), -- Trim leading/trailing spaces
				id = id:match("^%S+"), -- Get the non-space ID
				type = type:match("^%s*(.-)%s*$") -- Trim leading/trailing spaces
			})
		end
	end

	return devices
end
function get_flutter_devices_temp()
	local devices_list = run_shell_command("flutter devices")
	local devices = {}

	for line in devices_list:gmatch("[^\r\n]+") do
		local name, id, type = line:match("([^•]+)•%s*([^•]+)•%s*([^•]+)")
		if name and id and type then
			table.insert(devices, {
				name = name:match("%s*(.+)%s*"),
				id = id:match("%S+"),
				type = type:match("%s*(.+)%s*"),
			})
		end
	end

	return devices
end

-- Function to open a tab and run Flutter app
function run_flutter_app(device_id, flavor)
	local cmd = "fvm flutter run -d " .. device_id
	if flavor then
		cmd = "fvm flutter run -d " .. device_id .. " --flavor " .. flavor
	end
	vim.api.nvim_command("botright vsplit | vertical resize 50")
	--vim.api.nvim_command("split | horizontal resize 20")
	vim.api.nvim_command("term " .. cmd)
	terminal_bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_command("set modifiable")
	-- Wait for the terminal to be ready
	--vim.api.nvim_command("wincmd p")
	-- Move cursor to the end
	vim.api.nvim_feedkeys("G", "n", true)
end

function flutter_hot_reload()
	send_input_to_terminal("r")
end

function flutter_hot_restart()
	send_input_to_terminal("R")
end

function flutter_quit_app()
	send_input_to_terminal("q")
end

function send_input_to_terminal(keys)
	if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
		local prev_bufnr = vim.fn.bufnr("%")

		-- Switch to the terminal buffer temporarily
		vim.api.nvim_set_current_buf(terminal_bufnr)

		-- Enter insert mode, feed keys, and exit insert mode
		vim.api.nvim_command("normal! i")
		vim.api.nvim_feedkeys(keys, "n", true)
		vim.api.nvim_command("normal! <Esc>")
		-- putting delay to avoid changing buffer before entering keys in terminal
		vim.defer_fn(function()
			vim.api.nvim_set_current_buf(prev_bufnr)
		end, 1000)
	else
		print("No valid terminal buffer found.")
	end
end

-- Function to show Flutter devices and select a device to run the app
function show_flutter_devices(flavor, callback)
	local devices = get_flutter_devices()

	local lines = {}
	for i, device in ipairs(devices) do
		table.insert(lines, i .. ": " .. device.name .. " (" .. device.type .. ")")
	end

	local content = table.concat(lines, "\n")

	-- Create a floating window with the device selection dialog
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.fn.split(content, "\n"))

	local height = math.min(#lines + 2, 10) -- Limit height to a maximum of 10 lines for better visibility
	local win_id = vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = 100,
		height = height,
		row = (vim.fn.winheight(0) - height) / 2,
		col = (vim.fn.winwidth(0) - 30) / 2,
		style = "minimal",
		zindex = 50,
		border = "rounded",
	})
	if (callback) then
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<CR>", ":lua return_selected_device()<CR>)", {
			noremap = true,
			silent = true,
		})
	else
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<CR>", ":lua launch_selected_device()<CR>)", {
			noremap = true,
			silent = true,
		})
	end
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":lua close_device_selection()<CR>", {
		noremap = true,
		silent = true,
	})

	_G.return_selected_device = function()
		local line_number = vim.fn.line(".")
		local selected_device = devices[line_number]
		close_device_selection()
		callback(selected_device.id)
	end

	-- Clear the processing status in the bottom status line
	vim.api.nvim_command("echohl None | echo ''")

	-- Function to launch the selected device
	_G.launch_selected_device = function()
		local line_number = vim.fn.line(".")
		local selected_device = devices[line_number]

		if selected_device then
			run_flutter_app(selected_device.id, flavor)
			close_device_selection()
		end
	end

	-- Function to close the device selection window
	_G.close_device_selection = function()
		vim.api.nvim_win_close(win_id, true)
	end
end

-- Function to run all Flutter tools sequentially
function run_flutter_tools(flavor)
	-- Display processing status in the bottom status line
	vim.api.nvim_command("echohl WarningMsg | echo 'Opening available devices.....' | echohl None")

	-- Run Flutter tools asynchronously
	vim.defer_fn(function()
		show_flutter_devices(flavor)
		-- Add more functions here if needed

		-- Clear the processing status in the bottom status line
		vim.api.nvim_command("echohl None | echo ''")
	end, 0)
end
