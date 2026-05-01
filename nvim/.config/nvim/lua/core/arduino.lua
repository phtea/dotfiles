-- =========================
-- Arduino CLI Neovim Setup
-- =========================

local arduino = {
  fqbn = "arduino:avr:nano:cpu=atmega328old",
  baud = "9600",
}

-- -------------------------
-- Port detection
-- -------------------------
local function get_port()
  local output = vim.fn.system("arduino-cli board list --format json")

  local ok, data = pcall(vim.fn.json_decode, output)
  if ok and data and data.detected_ports then
    for _, entry in ipairs(data.detected_ports) do
      if entry.port and entry.port.address then
        return entry.port.address
      end
    end
  end

  return "/dev/ttyACM0"
end

-- -------------------------
-- Build
-- -------------------------
vim.api.nvim_create_user_command("ArduinoBuild", function()
  vim.cmd("write")

  local cmd = string.format(
    "arduino-cli compile --fqbn %s .",
    arduino.fqbn
  )

  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Arduino build failed:\n" .. output, vim.log.levels.ERROR)
    return
  end

  vim.notify("Build successful", vim.log.levels.INFO)
end, {})

-- -------------------------
-- Upload
-- -------------------------
vim.api.nvim_create_user_command("ArduinoUpload", function()
  vim.cmd("write")

  local port = get_port()
  local build_dir = "/tmp/arduino-build"

  local cmd = string.format(
    "arduino-cli compile --fqbn %s . --build-path %s && arduino-cli upload -p %s --fqbn %s --input-dir %s",
    arduino.fqbn,
    build_dir,
    port,
    arduino.fqbn,
    build_dir
  )

  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Upload failed:\n" .. output, vim.log.levels.ERROR)
    return
  end

  vim.notify("Upload successful on " .. port, vim.log.levels.INFO)
end, {})

-- -------------------------
-- Serial monitor toggle
-- -------------------------
local serial_job = nil

vim.api.nvim_create_user_command("ArduinoSerial", function()
  local port = get_port()

  if serial_job then
    vim.fn.jobstop(serial_job)
    serial_job = nil
    vim.notify("Serial stopped")
    return
  end

  serial_job = vim.fn.termopen(
    string.format(
      "arduino-cli monitor -p %s -c baudrate=%s",
      port,
      arduino.baud
    )
  )

  vim.notify("Serial started on " .. port)
end, {})

-- -------------------------
-- Keymaps
-- -------------------------
local map = vim.keymap.set

map("n", "<leader>ab", "<cmd>ArduinoBuild<CR>", { desc = "Arduino Build" })
map("n", "<leader>au", "<cmd>ArduinoUpload<CR>", { desc = "Arduino Upload" })
map("n", "<leader>am", "<cmd>ArduinoSerial<CR>", { desc = "Arduino Serial Toggle" })
map("n", "<leader>ap", function()
  vim.notify(get_port())
end, { desc = "Arduino Show Port" })
