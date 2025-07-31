-- flutter_emulators.lua

-- Function to run shell commands
function run_shell_command(command)
	local handle
	if vim.loop.os_uname().sysname == "Darwin" then
		-- macOS
		handle = io.popen(command, "r+")
	else
		-- Linux and others
		handle = io.popen(command .. " &", "r")
	end
	local result = handle:read("*a")
	handle:close()
	return result
end

-- Function to get a list of available Flutter emulators
function get_flutter_emulators()
	local emulators_list = run_shell_command("flutter emulators")
	local emulators = {}
	local start_parsing = false -- Flag to skip header lines

	for line in emulators_list:gmatch("[^\r\n]+") do
		-- Start parsing after encountering the header
		if line:match("^Id%s+•%s+Name%s+•%s+Manufacturer%s+•%s+Platform") then
			start_parsing = true
		elseif start_parsing then
			-- Match lines with emulator details: Id • Name • Manufacturer • Platform
			local id, name, manufacturer, platform = line:match("([^•]+)•%s*([^•]+)•%s*([^•]+)•%s*([^•]+)")
			if id and name and manufacturer and platform then
				table.insert(
					emulators,
					{
						id = id:match("%S+"), -- Trim and clean up id
						name = name:match("^%s*(.-)%s*$"), -- Trim name
						manufacturer = manufacturer:match("^%s*(.-)%s*$"), -- Trim manufacturer
						platform = platform:match("^%s*(.-)%s*$") -- Trim platform
					}
				)
			end
		end
	end

	return emulators
end

-- Function to launch the selected Flutter emulator
function launch_selected_emulator()
	local line_number = vim.fn.line(".")
	local emulator_id = vim.fn.matchlist(vim.fn.getline(line_number), "\\v^([^:]+):")[2]

	if emulator_id then
		run_shell_command("flutter emulators --launch " .. emulator_id)
		close_emulators_window()
	end
end

-- Function to close the Flutter emulators window
function close_emulators_window()
	local bufnr = vim.api.nvim_get_current_buf()
	local win_id = vim.api.nvim_get_current_win()

	vim.api.nvim_buf_delete(bufnr, { force = true })
	vim.api.nvim_win_close(win_id, true)
end

function show_flutter_emulators()
	local emulators = get_flutter_emulators()
	-- Calculate window dimensions and position
	local width = 60
	local height = #emulators + 2
	local row = (vim.fn.winheight(0) - height) / 2
	local col = (vim.fn.winwidth(0) - width) / 2

	-- Create the content
	local lines = {}
	for _, emulator in ipairs(emulators) do
		table.insert(
			lines,
			emulator.id ..
			": " .. emulator.name .. " (" .. emulator.manufacturer .. " - " .. emulator.platform .. ")"
		)
	end

	local content = table.concat(lines, "\n")

	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.fn.split(content, "\n"))

	local win_id = vim.api.nvim_open_win(bufnr, true, {
		relative = "win",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		zindex = 50,
		border = "rounded",
	})

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<CR>",
		":lua launch_selected_emulator()<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":lua close_emulators_window()<CR>",
		{ noremap = true, silent = true })

	vim.api.nvim_win_set_option(win_id, "winblend", 50)
end
