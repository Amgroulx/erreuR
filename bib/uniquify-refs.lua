-- scripts/uniquify-refs.lua
-- Parcourt bib/*.html après leur rendu et renomme id="refs" => id="refs-<nom de fichier>"
-- pour éviter l'empilement quand on inclut plusieurs biblios sur la même page.

local lfs = require("lfs")

local function read(path)
  local f = io.open(path, "r"); if not f then return nil end
  local s = f:read("*a"); f:close(); return s
end

local function write(path, s)
  local f = io.open(path, "w"); assert(f, "cannot write "..path)
  f:write(s); f:close()
end

local function uniquify_in_dir(dir)
  for file in lfs.dir(dir) do
    if file:match("%.html$") then
      local base = file:gsub("%.html$", "")
      local path = dir.."/"..file
      local s = read(path)
      if s then
        -- rends chaque id unique
        s = s:gsub('id="refs"', 'id="refs-'..base..'"')
        s = s:gsub('id="bibliography"', 'id="bibliography-'..base..'"')
        write(path, s)
      end
    end
  end
end

-- Exécute seulement si le dossier bib/ existe
local ok = lfs.chdir("bib")
if ok then
  lfs.chdir("..") -- reviens racine
  uniquify_in_dir("bib")
end
