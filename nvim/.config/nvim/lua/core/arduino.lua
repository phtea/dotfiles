local arduino = {
  fqbn = "arduino:avr:nano:cpu=atmega328old",
  baud = "9600",
	port = nil,
}

local function load_port_async()
  vim.fn.jobstart({ "arduino-cli", "board", "list", "--format", "json" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local output = table.concat(data, "\n")
      local ok, decoded = pcall(vim.json.decode, output)

      if ok and decoded and decoded.detected_ports then
        for _, entry in ipairs(decoded.detected_ports) do
          if entry.port and entry.port.address then
            arduino.port = entry.port.address
            vim.notify("Arduino port detected: " .. arduino.port)
            return
          end
        end
      end
    end,
  })
end

vim.api.nvim_create_autocmd("FileType", { pattern = "arduino", callback = load_port_async, })

local function open_qf_list(opts)
	vim.fn.setqflist({}, ' ', opts)
	vim.cmd("cwindow")
end

local function tell_status(title)
	if vim.v.shell_error ~= 0 then
		vim.notify(title .. " failed", vim.log.levels.ERROR)
	else
		vim.notify(title .. " successful on " .. arduino.port, vim.log.levels.INFO)
	end
end

vim.api.nvim_create_user_command("ArduinoBuild", function()
	local cmd = string.format("arduino-cli compile --fqbn %s .", arduino.fqbn)
	local output = vim.fn.systemlist(cmd)

	open_qf_list({ title = "Arduino Upload", lines = output })
	tell_status("Build")
end, {})

vim.api.nvim_create_user_command("ArduinoUpload", function()
	local cmd = string.format("arduino-cli compile --fqbn %s . && arduino-cli upload -p %s --fqbn %s .", arduino.fqbn, arduino.port, arduino.fqbn)

	local output = vim.fn.systemlist(cmd)
	open_qf_list({ title = "Arduino Build", lines = output })
	tell_status("Upload")
end, {})

local serial_job = nil
vim.api.nvim_create_user_command("ArduinoSerial", function()
	vim.cmd("enew")
	if serial_job then
		vim.fn.jobstop(serial_job)
		serial_job = nil
	end

	local command = string.format("arduino-cli monitor -p %s -c baudrate=%s", arduino.port, arduino.baud)
	serial_job = vim.fn.jobstart(command, { term = true })
end, {})

vim.keymap.set("n", "<leader>ab", "<cmd>ArduinoBuild<CR>", { desc = "Arduino Build" })
vim.keymap.set("n", "<leader>au", "<cmd>ArduinoUpload<CR>", { desc = "Arduino Upload" })
vim.keymap.set("n", "<leader>am", "<cmd>ArduinoSerial<CR>", { desc = "Arduino Serial Monitor" })
