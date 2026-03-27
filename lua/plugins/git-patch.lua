local function export_patch()
	local diff = vim.fn.system("git diff")
	if vim.v.shell_error ~= 0 or diff == "" then
		diff = vim.fn.system("git diff --cached")
	end
	if diff == "" then
		vim.notify("No changes to export", vim.log.levels.WARN)
		return
	end
	vim.fn.setreg("+", diff)
	vim.notify("Patch copied to clipboard", vim.log.levels.INFO)
end

local function import_patch()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local content = table.concat(lines, "\n") .. "\n"
	if content == "" then
		vim.notify("Buffer is empty", vim.log.levels.WARN)
		return
	end
	local result = vim.fn.system("git apply -", content)
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to apply patch:\n" .. result, vim.log.levels.ERROR)
	else
		vim.notify("Patch applied", vim.log.levels.INFO)
	end
end

return {
	dir = "git-patch",
	name = "git-patch",
	virtual = true,
	lazy = false,
	keys = {
		{ "<leader>gpe", export_patch, mode = "n", desc = "Export git patch to clipboard" },
		{ "<leader>gpi", import_patch, mode = "n", desc = "Import git patch from buffer" },
	},
	config = function() end,
}
