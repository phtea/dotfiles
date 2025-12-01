-- Directory that contains this file and all custom_code config files
local custom_code_dir = vim.fn.stdpath("config") .. "/lua/custom_code"

-- Auto load custom_code settings
for _, file in ipairs(vim.fn.readdir(custom_code_dir)) do
	-- Only *.lua and skip this init.lua itself
	if file:match("%.lua$") and file ~= "init.lua" then
		local mod_name = file:gsub("%.lua$", "")
		local ok, err = pcall(require, "custom_code." .. mod_name)
		if not ok then
			vim.notify(
				"Error loading custom_code config: " .. mod_name .. "\n" .. err,
				vim.log.levels.ERROR
			)
		end
	end
end
