local M = {}

---@class Config
---@field default_mappings boolean
---@field step_size number
---@field notifications NotificationOpts
---@field reset_font string

---@class NotificationOpts
---@field enable boolean
---@field delay number
---@field timeout number

---@type Config
M.defaults = {
	default_mappings = true,
	step_size = 1,
	notifications = {
		enable = true,
		delay = 300,
		timeout = 150,
	},
	reset_font_size = 14,
}

return M
