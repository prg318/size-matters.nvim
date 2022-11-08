if vim.fn.has "nvim-0.7.0" == 0 then
	vim.api.nvim_err_writeln "size-matters requires nvim version 0.7 or above"
	return
end

if vim.g.loaded_size_matters == 1 then return end
vim.g.loaded_size_matters = 1
