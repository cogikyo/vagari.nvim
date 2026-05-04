local treesitter = {}

local function first_node(nodes)
	if type(nodes) == "table" then
		return nodes[1]
	end
	return nodes
end

local function escape_pattern(text)
	return text:gsub("([^%w])", "%%%1")
end

function treesitter.setup()
	vim.treesitter.query.add_predicate("go-doc-comment?", function(match, _, bufnr, pred)
		local comment = first_node(match[pred[2]])
		local name_node = first_node(match[pred[3]])
		if not comment or not name_node then
			return false
		end

		local name = vim.treesitter.get_node_text(name_node, bufnr)
		local text = vim.treesitter.get_node_text(comment, bufnr)
		local prefix = "^//%s*" .. escape_pattern(name) .. "%f[%W]"
		return text:match(prefix) ~= nil
	end, { force = true })
end

return treesitter
