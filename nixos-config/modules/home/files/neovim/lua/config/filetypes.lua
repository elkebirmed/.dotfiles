-- ===========================================================================
-- Filetype detection
-- ===========================================================================
-- Some language servers only attach to compound filetypes that Neovim does
-- not detect on its own (`yaml.docker-compose`, `helm`, ...). They are
-- declared here, otherwise those servers never start.

---@param path string
---@return string[]
local function path_dirs(path)
    local dirs = {}
    for dir in vim.fs.dirname(path):gmatch("[^/]+") do
        table.insert(dirs, dir)
    end
    return dirs
end

---@param path string
---@return boolean
local function is_helm_template(path)
    for _, dir in ipairs(path_dirs(path)) do
        if dir == "templates" then
            return true
        end
    end
    return false
end

---@param path string
---@return string
local function detect_yaml(path)
    -- Helm templates are Go templates: the Helm language server only offers
    -- its template features when the file is not announced as plain YAML.
    if is_helm_template(path) then
        return "helm"
    end
    return "yaml"
end

vim.filetype.add({
    filename = {
        -- Docker Compose
        ["compose.yaml"] = "yaml.docker-compose",
        ["compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["docker-compose.yml"] = "yaml.docker-compose",
        -- Docker Bake
        ["docker-bake.hcl"] = "hcl.docker-bake",
        -- Helm values files
        ["values.yaml"] = "yaml.helm-values",
    },
    extension = {
        yaml = detect_yaml,
        yml = detect_yaml,
    },
})

-- The `helm` filetype has no syntax file of its own, but Helm templates are
-- YAML with Go template markers: keep the YAML highlighting. The runtime sets
-- 'syntax' from the filetype right after this event, so the YAML syntax is
-- applied once the filetype is fully set.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_filetypes", { clear = true }),
    pattern = "helm",
    callback = function(args)
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
                vim.bo[args.buf].syntax = "yaml"
            end
        end)
    end,
})
