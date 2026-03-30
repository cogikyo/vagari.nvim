local vagari = {}

vagari.load = function()
	if vim.version().minor < 9 then
		vim.notify_once("vagari.nvim: neovim 0.9 or higher required")
		return
	end

	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end

	vim.o.termguicolors = true
	vim.g.colors_name = "vagari"

	require("vagari.highlights").setup()
	require("vagari.lsp").setup()
	require("vagari.languages").setup()
	require("vagari.plugins").setup()

	local plugin_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
	if not vagari._dev_autocmd then
		vagari._dev_autocmd = true
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = vim.api.nvim_create_augroup("VagariDevReload", { clear = true }),
			pattern = plugin_dir .. "/*",
			callback = function(ev)
				for name, _ in pairs(package.loaded) do
					if name:match("^vagari") then
						package.loaded[name] = nil
					end
				end
				require("vagari").load()
				vim.notify("vagari: reloaded", vim.log.levels.INFO)
			end,
		})
	end
end

return vagari
