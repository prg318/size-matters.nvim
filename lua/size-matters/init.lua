local M = {}

local notifications = require "size-matters.notifications"
local config = require("size-matters.config").defaults

---@param user_config? Config
function M.setup(user_config) config = vim.tbl_deep_extend("keep", user_config or {}, config) end

---@type string?
local guifont

---@type { name: string, size: string|number }
local curr_font = {}

local function get_font()
	guifont = vim.api.nvim_get_option "guifont"
	curr_font.name = guifont:reverse():match(".+%:(.*)"):reverse()
	curr_font.size = guifont:match "%:h(%d+%.?%d?)"
end

---@param modification "grow"|"shrink"
---@param amount? number|string
function M.update_font(modification, amount)
	if vim.fn.has('gui_running') == 0 then return end
	get_font()

	---@cast amount number
	amount = type(amount) == "string" and tonumber(amount) or config.step_size
	curr_font.size = type(curr_font.size) == "string" and tonumber(curr_font.size) or curr_font.size

	if modification == "grow" then
		guifont = curr_font.name .. ":h" .. tostring(curr_font.size + amount)

		if config.notifications.enable then
			notifications.send(" FontSize " .. curr_font.size + amount, config.notifications)
		end
	elseif modification == "shrink" then
		guifont = curr_font.name .. ":h" .. tostring(curr_font.size - amount)

		if config.notifications.enable then
			notifications.send(" FontSize " .. curr_font.size - amount, config.notifications)
		end
	end
	if vim.g.neovide then
		vim.o.guifont = guifont
	else
		vim.cmd(":GuiFont! " .. guifont)
	end
end

function M.reset_font()
	local font_reset_string = string.match(vim.api.nvim_get_option "guifont", "(.+):") .. ":h" .. config.reset_font_size
	vim.cmd(":GuiFont! " .. font_reset_string)

	if not config.notifications or not config.notifications.enable then return end
	notifications.send(" " .. font_reset_string, config.notifications)
end

local cmd = vim.api.nvim_create_user_command
cmd("FontSizeUp", function(num) M.update_font("grow", num.args) end, { nargs = "?" })
cmd("FontSizeDown", function(num) M.update_font("shrink", num.args) end, { nargs = "?" })
cmd("FontReset", function() M.reset_font() end, {})

if config.default_mappings then
	local map = vim.keymap.set
	map("n", "<C-+>", function() M.update_font "grow" end, { desc = "Increase font size" })
	map("n", "<C-=>", function() M.update_font "grow" end, { desc = "Increase font size" })
	map("n", "<C-S-+>", function() M.update_font "grow" end, { desc = "Increase font size" })
	map("n", "<C-->", function() M.update_font "shrink" end, { desc = "Decrease font size" })
	map("n", "<C-ScrollWheelUp>", function() M.update_font "grow" end, { desc = "Increase font size" })
	map("n", "<C-ScrollWheelDown>", function() M.update_font "shrink" end, { desc = "Decrease font size" })
	map("n", "<C-0>", M.reset_font, { desc = "Reset to default font" })
	map("i", "<C-+>", function() M.update_font "grow" end, { desc = "Increase font size" })
	map("i", "<C-=>", function() M.update_font "grow" end, { desc = "Increase font size" })
	map("i", "<C-S-+>", function() M.update_font "grow" end, { desc = "Increase font size" })
	map("i", "<C-->", function() M.update_font "shrink" end, { desc = "Decrease font size" })
	map("i", "<C-ScrollWheelUp>", function() M.update_font "grow" end, { desc = "Increase font size" })
	map("i", "<C-ScrollWheelDown>", function() M.update_font "shrink" end, { desc = "Decrease font size" })
	map("i", "<A-C-=>", M.reset_font, { desc = "Reset to default font" })
end

return M
