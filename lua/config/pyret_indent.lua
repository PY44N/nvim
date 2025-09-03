-- Translated to Lua from https://github.com/brownplt/pyret-lang/blob/horizon/tools/vim/indent/pyret.vim 

local M = {}

local function is_word_boundary(line, pos)
  if pos == 1 then return true end
  if pos > #line then return true end
  local prev_char = string.sub(line, pos - 1, pos - 1)
  local curr_char = string.sub(line, pos, pos)
  return not (string.match(prev_char, "[%w_%-]") and string.match(curr_char, "[%w_%-]"))
end

local function line_starts_with_words(line, words)
  local trimmed = string.match(line, "^%s*(.*)$")
  if not trimmed then return false end
  
  for word in string.gmatch(words, "([^|]+)") do
    if string.sub(trimmed, 1, #word) == word then
      if #trimmed == #word or not string.match(string.sub(trimmed, #word + 1, #word + 1), "[%w_%-:]") then
        return true
      end
    end
  end
  return false
end

local function matches_opening_words(line)
  return line_starts_with_words(line, "ask|cases|catch|check|data|for|fun|if|sharing|switch|try|when|while")
end

local function matches_middle_words(line)
  return line_starts_with_words(line, "case|catch|else|elseif|sharing|where")
end

local function matches_closing_words(line)
  return line_starts_with_words(line, "end")
end

local function matches_opening_brace(line)
  local hash_pos = string.find(line, "#")
  local brace_pos = string.find(line, "{")
  if brace_pos and (not hash_pos or brace_pos < hash_pos) then
    return string.match(line, "{%s*$") ~= nil
  end
  return false
end

local function matches_closing_brace(line)
  return string.match(line, "^%s*}") ~= nil
end

local function matches_opening_struct(line)
  local hash_pos = string.find(line, "#")
  local bracket_pos = string.find(line, "%[")
  if bracket_pos and (not hash_pos or bracket_pos < hash_pos) then
    return string.match(line, "%[[%w%-_]+:%s*$") ~= nil
  end
  return false
end

local function matches_closing_struct(line)
  return string.match(line, "^%s*%]") ~= nil
end

local function matches_opening_function(line)
  local hash_pos = string.find(line, "#")
  local paren_pos = string.find(line, "%):")
  if paren_pos and (not hash_pos or paren_pos < hash_pos) then
    return string.match(line, "%):%s*$") ~= nil
  end
  return false
end

local function matches_pipe(line)
  return string.match(line, "^%s*|") ~= nil
end

local function matches_opener(line)
  return matches_opening_words(line) or matches_middle_words(line) or 
         matches_opening_brace(line) or matches_opening_function(line) or matches_opening_struct(line)
end

local function matches_closer(line)
  return matches_closing_words(line) or matches_middle_words(line) or 
         matches_closing_brace(line) or matches_closing_struct(line)
end

local function pyret_indent_closing_pipe(cnum)
  local pnum = cnum - 1
  local unmatched_ends = 0
  
  while pnum > 0 do
    local pline = vim.fn.getline(pnum)
    if matches_pipe(pline) then
      if unmatched_ends == 0 then
        return true
      end
    elseif matches_closer(pline) and not matches_opener(pline) then
      unmatched_ends = unmatched_ends + 1
    elseif matches_opener(pline) and not matches_closer(pline) then
      if unmatched_ends <= 0 then
        return false
      else
        unmatched_ends = unmatched_ends - 1
      end
    end
    pnum = pnum - 1
  end
  
  return false
end

function M.get_pyret_indent(cnum)
  local pnum = cnum - 1
  
  -- Find previous non-empty line
  while pnum > 0 and string.match(vim.fn.getline(pnum), "^%s*$") do
    pnum = pnum - 1
  end
  
  if pnum == 0 then
    return 0
  end
  
  local sugg_indent = vim.fn.indent(pnum)
  local cline = vim.fn.getline(cnum)
  local pline = vim.fn.getline(pnum)
  
  if matches_closer(cline) then
    if not matches_opener(pline) then
      sugg_indent = sugg_indent - vim.bo.shiftwidth
      if not matches_pipe(pline) and pyret_indent_closing_pipe(cnum) then
        sugg_indent = sugg_indent - vim.bo.shiftwidth
      end
    end
  elseif matches_opener(cline) then
    if matches_opener(pline) or matches_pipe(pline) then
      sugg_indent = sugg_indent + vim.bo.shiftwidth
    end
  elseif matches_pipe(cline) then
    if matches_opener(pline) then
      sugg_indent = sugg_indent + vim.bo.shiftwidth
    elseif matches_pipe(pline) then
      -- stay put
    else
      sugg_indent = sugg_indent - vim.bo.shiftwidth
    end
  else
    if matches_opener(pline) or matches_pipe(pline) then
      sugg_indent = sugg_indent + vim.bo.shiftwidth
    end
  end
  
  return math.max(0, sugg_indent)
end

return M