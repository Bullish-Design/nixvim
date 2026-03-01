-- nvim/lua/ui/starter_config.lua
-- Configurable starter screen: global actions, project sessions, project-specific actions

local M = {}

-- ─── Global actions (user-configurable) ──────────────────────────────────────
-- Each entry: { name, action, section }
-- To customize: edit this table.
M.global_actions = {
  { name = "Find File",    action = [[lua MiniPick.builtin.files()]],     section = "Actions" },
  { name = "Live Grep",    action = [[lua MiniPick.builtin.grep_live()]], section = "Actions" },
  { name = "Recent Files", action = "browse oldfiles",                    section = "Actions" },
  { name = "New File",     action = "enew | startinsert",                 section = "Actions" },
  { name = "Quit",         action = "qa",                                 section = "Actions" },
}

-- ─── Project detection ───────────────────────────────────────────────────────
-- Walk up from cwd looking for root markers. Returns project root or nil.
local root_markers = { ".git", "Makefile", "package.json", "Cargo.toml", "pyproject.toml", "flake.nix", "go.mod" }

function M.find_project_root()
  local path = vim.fn.getcwd()
  for _ = 1, 20 do
    for _, marker in ipairs(root_markers) do
      if vim.fn.isdirectory(path .. "/" .. marker) == 1 or vim.fn.filereadable(path .. "/" .. marker) == 1 then
        return path
      end
    end
    local parent = vim.fn.fnamemodify(path, ":h")
    if parent == path then break end
    path = parent
  end
  return nil
end

-- ─── Project-specific actions ────────────────────────────────────────────────
-- Auto-detected from files in cwd. Users can add their own detectors.
M.project_detectors = {
  {
    marker = "pyproject.toml",
    actions = {
      { name = "Run pytest",     action = "!pytest",             section = "Project" },
      { name = "Open pyproject", action = "edit pyproject.toml", section = "Project" },
    },
  },
  {
    marker = "Cargo.toml",
    actions = {
      { name = "Cargo build",     action = "!cargo build",       section = "Project" },
      { name = "Cargo test",      action = "!cargo test",        section = "Project" },
      { name = "Open Cargo.toml", action = "edit Cargo.toml",    section = "Project" },
    },
  },
  {
    marker = "package.json",
    actions = {
      { name = "npm test",          action = "!npm test",            section = "Project" },
      { name = "Open package.json", action = "edit package.json",    section = "Project" },
    },
  },
  {
    marker = "flake.nix",
    actions = {
      { name = "Nix develop",    action = "!nix develop",    section = "Project" },
      { name = "Open flake.nix", action = "edit flake.nix",  section = "Project" },
    },
  },
  {
    marker = "go.mod",
    actions = {
      { name = "Go test",     action = "!go test ./...", section = "Project" },
      { name = "Open go.mod", action = "edit go.mod",    section = "Project" },
    },
  },
  {
    marker = "Makefile",
    actions = {
      { name = "Make",          action = "!make",          section = "Project" },
      { name = "Open Makefile", action = "edit Makefile",  section = "Project" },
    },
  },
}

function M.detect_project_actions()
  local actions = {}
  local cwd = vim.fn.getcwd()
  for _, detector in ipairs(M.project_detectors) do
    local path = cwd .. "/" .. detector.marker
    if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
      for _, action in ipairs(detector.actions) do
        table.insert(actions, action)
      end
    end
  end
  return actions
end

-- ─── Session items ───────────────────────────────────────────────────────────
-- Build starter items from mini.sessions detected sessions (top 5, most recent first).
function M.session_items()
  local ok, sessions = pcall(function() return require("mini.sessions").detected end)
  if not ok or not sessions then return {} end

  local sorted = {}
  for name, info in pairs(sessions) do
    table.insert(sorted, { name = name, modify_time = info.modify_time or 0 })
  end
  table.sort(sorted, function(a, b) return a.modify_time > b.modify_time end)

  local items = {}
  for i, session in ipairs(sorted) do
    if i > 5 then break end
    table.insert(items, {
      name = session.name,
      action = string.format([[lua MiniSessions.read("%s")]], session.name),
      section = "Sessions",
    })
  end
  return items
end

-- ─── Build all items ─────────────────────────────────────────────────────────
-- Combines sessions + global actions + project-specific actions.
function M.build_items()
  local items = {}
  vim.list_extend(items, M.session_items())
  vim.list_extend(items, M.global_actions)
  vim.list_extend(items, M.detect_project_actions())
  return items
end

return M
