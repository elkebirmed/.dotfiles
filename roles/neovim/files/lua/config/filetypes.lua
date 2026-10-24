-- ===========================================================================
-- Filetype detection
-- ===========================================================================
-- Some language servers only attach to compound filetypes that Neovim does
-- not detect on its own (`yaml.ansible`, `yaml.docker-compose`, `helm`, ...).
-- They are declared here, otherwise those servers never start.

-- Ansible files are recognised by their name or by the directory they live
-- in (roles/<role>/tasks, group_vars, host_vars, playbooks, ...).
local ansible_names = {
    ["defaults.yaml"] = true,
    ["defaults.yml"] = true,
    ["handlers.yaml"] = true,
    ["handlers.yml"] = true,
    ["playbook.yaml"] = true,
    ["playbook.yml"] = true,
    ["site.yaml"] = true,
    ["site.yml"] = true,
    ["tasks.yaml"] = true,
    ["tasks.yml"] = true,
    ["vars.yaml"] = true,
    ["vars.yml"] = true,
}

local ansible_dirs = {
    defaults = true,
    group_vars = true,
    handlers = true,
    host_vars = true,
    playbooks = true,
    tasks = true,
    vars = true,
}

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
local function is_ansible_file(path)
    if ansible_names[vim.fs.basename(path)] then
        return true
    end
    for _, dir in ipairs(path_dirs(path)) do
        if ansible_dirs[dir] then
            return true
        end
    end
    return false
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
    if is_ansible_file(path) then
        return "yaml.ansible"
    end
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
