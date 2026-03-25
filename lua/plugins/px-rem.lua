local base = 16

local function convert_value(text)
	if text:match("([%d%.]+)px") then
		local px = tonumber(text:match("([%d%.]+)px"))
		local rem = px / base
		local formatted = rem % 1 == 0 and string.format("%d", rem) or string.format("%g", rem)
		return text:gsub("[%d%.]+px", formatted .. "rem")
	elseif text:match("([%d%.]+)rem") then
		local rem = tonumber(text:match("([%d%.]+)rem"))
		local px = rem * base
		local formatted = px % 1 == 0 and string.format("%d", px) or string.format("%g", px)
		return text:gsub("[%d%.]+rem", formatted .. "px")
	end
	return nil
end

local function convert_cursor()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]

	for _, pattern in ipairs({ "[%d%.]+px", "[%d%.]+rem" }) do
		local s, e = 0, 0
		while true do
			s, e = line:find(pattern, e + 1)
			if not s then break end
			if col >= s - 1 and col <= e - 1 then
				local match = line:sub(s, e)
				local converted = convert_value(match)
				if converted then
					local new_line = line:sub(1, s - 1) .. converted .. line:sub(e + 1)
					vim.api.nvim_set_current_line(new_line)
					return
				end
			end
		end
	end
	vim.notify("No px/rem value under cursor", vim.log.levels.WARN)
end

local function convert_line()
	local line = vim.api.nvim_get_current_line()
	local new_line = line:gsub("[%d%.]+px", function(match)
		return convert_value(match) or match
	end)
	if new_line == line then
		new_line = line:gsub("[%d%.]+rem", function(match)
			return convert_value(match) or match
		end)
	end
	if new_line ~= line then
		vim.api.nvim_set_current_line(new_line)
	else
		vim.notify("No px/rem values on this line", vim.log.levels.WARN)
	end
end

local function set_base(args)
	local new_base = tonumber(args.args)
	if new_base and new_base > 0 then
		base = new_base
		vim.notify("px-rem base set to " .. base .. "px", vim.log.levels.INFO)
	else
		vim.notify("Current base: " .. base .. "px", vim.log.levels.INFO)
	end
end

return {
	dir = "px-rem",
	name = "px-rem",
	virtual = true,
	lazy = false,
	keys = {
		{ "<leader>px", convert_line, mode = "n", desc = "Convert all px/rem on line" },
		{ "<leader>pX", convert_cursor, mode = "n", desc = "Convert px/rem under cursor" },
	},
	config = function()
		vim.api.nvim_create_user_command("PxRemBase", set_base, { nargs = "?" })
	end,
}
