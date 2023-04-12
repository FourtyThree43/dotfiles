local color_schemes = vim.fn.execute("colorscheme")
local current_scheme = 1

vim.api.nvim_command("command! CycleColorScheme lua require('color_scheme').cycle()")
vim.api.nvim_command("command! PreviousColorScheme lua require('color_scheme').previous()")
vim.api.nvim_command("command! RandomColorScheme lua require('color_scheme').random()")

vim.api.nvim_command("nnoremap <F8> :CycleColorScheme<CR>")
vim.api.nvim_command("nnoremap <F6> :PreviousColorScheme<CR>")
vim.api.nvim_command("nnoremap <F7> :RandomColorScheme<CR>")

local color_scheme = {}

function color_scheme.cycle()
	current_scheme = current_scheme + 1
	if current_scheme > #color_schemes then
		current_scheme = 1
	end

	vim.api.nvim_command("colorscheme " .. color_schemes[current_scheme])
end

function color_scheme.previous()
	current_scheme = current_scheme - 1
	if current_scheme < 1 then
		current_scheme = #color_schemes
	end

	vim.api.nvim_command("colorscheme " .. color_schemes[current_scheme])
end

function color_scheme.random()
	current_scheme = math.random(#color_schemes)
	vim.api.nvim_command("colorscheme " .. color_schemes[current_scheme])
end

return color_scheme
