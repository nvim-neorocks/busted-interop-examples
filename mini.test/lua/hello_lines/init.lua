local M = {}

--- Prepend 'Hello ' to every element
---@param lines table Array. Default: { 'world' }.
---@return table Array of strings.
M.compute = function(lines)
	lines = lines or { "world" }
	return vim.tbl_map(function(x)
		return "Hello " .. tostring(x)
	end, lines)
end

local ns_id = vim.api.nvim_create_namespace("hello_lines")

--- Set lines with highlighted 'Hello ' prefix
---@param buf_id number Buffer handle where lines should be set. Default: 0.
---@param lines table Array. Default: { 'world' }.
M.set_lines = function(buf_id, lines)
	buf_id = buf_id or 0
	lines = lines or { "world" }
	vim.api.nvim_buf_set_lines(buf_id or 0, 0, -1, true, M.compute(lines))
	for i = 1, #lines do
		vim.highlight.range(buf_id, ns_id, "Special", { i - 1, 0 }, { i - 1, 5 }, {})
	end
end

return M
