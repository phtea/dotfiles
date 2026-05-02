local function read_json(path)
	local expanded = vim.fn.expand(path)

	if vim.fn.filereadable(expanded) == 0 then
		return nil
	end

	local content = table.concat(vim.fn.readfile(expanded), "\n")
	local ok, decoded = pcall(vim.json.decode, content)

	if not ok then
		vim.notify("Invalid Arduino config: " .. expanded, vim.log.levels.ERROR)
		return nil
	end

	return decoded
end

local function load_config()
	local defaults = { fqbn = "arduino:avr:nano:cpu=atmega328old", baud = "9600", port = nil, }

	local global = read_json("~/.arduino.json") or {}
	local local_config = read_json(".arduino.json") or {}

	return vim.tbl_deep_extend("force", defaults, global, local_config)
end

local arduino = load_config()

vim.lsp.config('arduino_language_server', {
	cmd = { "arduino-language-server", "-fqbn", arduino.fqbn }
})

local serial_job = nil

local function open_qf_list(opts)
	vim.fn.setqflist({}, " ", opts)
	vim.cmd("cwindow")
end

local function run_async(title, args, on_success)
	vim.notify(title .. " started...", vim.log.levels.INFO)

	vim.system(args, { text = true }, function(result)
		vim.schedule(function()
			local output = {}

			for line in (result.stdout or ""):gmatch("[^\r\n]+") do
				table.insert(output, line)
			end

			for line in (result.stderr or ""):gmatch("[^\r\n]+") do
				table.insert(output, line)
			end

			open_qf_list({ title = "Arduino " .. title, lines = output, })

			if result.code ~= 0 then
				vim.notify(title .. " failed", vim.log.levels.ERROR)
			else
				local msg = title .. " successful"
				if arduino.port then
					msg = msg .. " on " .. arduino.port
				end
				vim.notify(msg, vim.log.levels.INFO)

				if on_success then
					on_success()
				end
			end
		end)
	end)
end

local function load_port_async()
	vim.system({ "arduino-cli", "board", "list", "--format", "json" }, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				vim.notify("Arduino port detection failed", vim.log.levels.ERROR)
				return
			end

			local ok, decoded = pcall(vim.json.decode, result.stdout)

			if ok and decoded and decoded.detected_ports then
				for _, entry in ipairs(decoded.detected_ports) do
					if entry.port and entry.port.address then
						arduino.port = entry.port.address
						vim.notify("Arduino port detected: " .. arduino.port)
						return
					end
				end
			end

			vim.notify("No Arduino port detected", vim.log.levels.WARN)
		end)
	end)
end

local function require_port()
	if arduino.port then return true end

	vim.notify("No Arduino port yet. Run :ArduinoDetectPort", vim.log.levels.WARN)
	load_port_async()
	return false
end

vim.api.nvim_create_user_command("ArduinoDetectPort", load_port_async, {})

vim.api.nvim_create_autocmd("FileType", { pattern = "arduino", callback = load_port_async, })

vim.api.nvim_create_user_command("ArduinoBuild", function()
	run_async("Build", { "arduino-cli", "compile", "--fqbn", arduino.fqbn, ".", })
end, {})

vim.api.nvim_create_user_command("ArduinoUpload", function()
	if not require_port() then return end

	run_async("Upload", { "arduino-cli", "compile", "--upload", "-p", arduino.port, "--fqbn", arduino.fqbn, ".", })
end, {})

vim.api.nvim_create_user_command("ArduinoSerial", function()
	if not require_port() then return end

	if serial_job then
		vim.fn.jobstop(serial_job)
		serial_job = nil
		return
	end

	vim.cmd("enew")

	serial_job = vim.fn.jobstart({ "arduino-cli", "monitor", "-p", arduino.port, "-c", "baudrate=" .. arduino.baud, }, {
		term = true,
		on_exit = function() serial_job = nil end,
	})
end, {})

vim.api.nvim_create_user_command("ArduinoReloadConfig", function()
	arduino = load_config()
	vim.notify("Arduino config reloaded: " .. arduino.fqbn)
end, {})

vim.keymap.set("n", "<leader>ab", "<CMD>ArduinoBuild<CR>", { desc = "Arduino Build" })
vim.keymap.set("n", "<leader>au", "<CMD>ArduinoUpload<CR>", { desc = "Arduino Upload" })
vim.keymap.set("n", "<leader>am", "<CMD>ArduinoSerial<CR>", { desc = "Arduino Serial Monitor" })
vim.keymap.set("n", "<leader>ap", "<CMD>ArduinoDetectPort<CR>", { desc = "Arduino Detect Port" })
