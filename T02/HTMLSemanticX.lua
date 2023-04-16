function newParser()

  XmlParser = {};

  function XmlParser:ToXmlString(value)
        value = string.gsub(value, "&", "&amp;"); -- '&' -> "&amp;"
        value = string.gsub(value, "<", "&lt;"); -- '<' -> "&lt;"
        value = string.gsub(value, ">", "&gt;"); -- '>' -> "&gt;"
        value = string.gsub(value, "\"", "&quot;"); -- '"' -> "&quot;"
        value = string.gsub(value, "([^%w%&%;%p%\t% ])",
          function(c)
            return string.format("&#x%X;", string.byte(c))
          end);
        return value;
      end

      function XmlParser:FromXmlString(value)
        value = string.gsub(value, "&#x([%x]+)%;",
          function(h)
            return string.char(tonumber(h, 16))
          end);
        value = string.gsub(value, "&#([0-9]+)%;",
          function(h)
            return string.char(tonumber(h, 10))
          end);
        value = string.gsub(value, "&quot;", "\"");
        value = string.gsub(value, "&apos;", "'");
        value = string.gsub(value, "&gt;", ">");
        value = string.gsub(value, "&lt;", "<");
        value = string.gsub(value, "&amp;", "&");
        return value;
      end

      function XmlParser:ParseArgs(node, s)
        string.gsub(s, "(%w+)=([\"'])(.-)%2", function(w, _, a)
          node:addProperty(w, self:FromXmlString(a))
        end)
      end

      function XmlParser:ParseXmlText(xmlText)
        local stack = {}
        local top = newNode()
        table.insert(stack, top)
        local ni, c, label, xarg, empty
        local i, j = 1, 1
        while true do
          ni, j, c, label, xarg, empty = string.find(xmlText, "<(%/?)([%w_:]+)(.-)(%/?)>", i)
          if not ni then break end
          local text = string.sub(xmlText, i, ni - 1);
          if not string.find(text, "^%s*$") then
            local lVal = (top:value() or "") .. self:FromXmlString(text)
            stack[#stack]:setValue(lVal)
          end
            if empty == "/" then -- empty element tag
            local lNode = newNode(label)
            self:ParseArgs(lNode, xarg)
            top:addChild(lNode)
            elseif c == "" then -- start tag
            local lNode = newNode(label)
            self:ParseArgs(lNode, xarg)
            table.insert(stack, lNode)
            top = lNode
            else -- end tag
                local toclose = table.remove(stack) -- remove top

                top = stack[#stack]
                if #stack < 1 then
                  error("XmlParser: nothing to close with " .. label)
                end
                if toclose:name() ~= label then
                  error("XmlParser: trying to close " .. toclose.name .. " with " .. label)
                end
                top:addChild(toclose)
              end
              i = j + 1
            end
            local text = string.sub(xmlText, i);
            if #stack > 1 then
              error("XmlParser: unclosed " .. stack[#stack]:name())
            end
            return top
          end

          function XmlParser:loadFile(xmlFilename, base)
            if not base then
              base = system.ResourceDirectory
            end

            local path = system.pathForFile(xmlFilename, base)
            local hFile, err = io.open(path, "r");

            if hFile and not err then
            local xmlText = hFile:read("*a"); -- read file content
            io.close(hFile);
            return self:ParseXmlText(xmlText), nil;
          else
            print(err)
            return nil
          end
        end

        return XmlParser
      end

      function newNode(name)
        local node = {}
        node.___value = nil
        node.___name = name
        node.___children = {}
        node.___props = {}

        function node:value() return self.___value end
        function node:setValue(val) self.___value = val end
        function node:name() return self.___name end
        function node:setName(name) self.___name = name end
        function node:children() return self.___children end
        function node:numChildren() return #self.___children end
        function node:addChild(child)
          if self[child:name()] ~= nil then
            if type(self[child:name()].name) == "function" then
              local tempTable = {}
              table.insert(tempTable, self[child:name()])
              self[child:name()] = tempTable
            end
            table.insert(self[child:name()], child)
          else
            self[child:name()] = child
          end
          table.insert(self.___children, child)
        end

        function node:properties() return self.___props end
        function node:numProperties() return #self.___props end
        function node:addProperty(name, value)
          local lName = "@" .. name
          if self[lName] ~= nil then
            if type(self[lName]) == "string" then
              local tempTable = {}
              table.insert(tempTable, self[lName])
              self[lName] = tempTable
            end
            table.insert(self[lName], value)
          else
            self[lName] = value
          end
          table.insert(self.___props, { name = name, value = self[name] })
        end

        return node
      end
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--
-- xml.lua - XML parser for use with the Corona SDK.
--
-- version: 1.2
--
-- CHANGELOG:
--
-- 1.2 - Created new structure for returned table
-- 1.1 - Fixed base directory issue with the loadFile() function.
--
-- NOTE: This is a modified version of Alexander Makeev's Lua-only XML parser
-- found here: http://lua-users.org/wiki/LuaXml
--
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function size(tbl)
  return #tbl
end

function trim(s)
  return s:match( '^%s*(.-)%s*$' )
end

function is_array(tbl) 
	return type(tbl) == 'table' and (#tbl > 0 or next(tbl) == nil) 
end

function to_array(tbl)
  return is_array(tbl) and tbl or {tbl}
end

function miligramRound(colNumber)
  print('miligramRound'..colNumber)
  --10
  if(colNumber<= 10)then
    return 10
  --15
  elseif(colNumber<= 15 and colNumber>= 10) then
    return 15
  --20
  elseif(colNumber<= 20 and colNumber>= 15) then
    return 20
  --25
  elseif(colNumber<= 25 and colNumber>= 20) then
    return 25
  --33
  elseif(colNumber<= 33 and colNumber>= 25) then
  return 33
  --40
  elseif(colNumber<= 40 and colNumber>= 33) then
  return 40
  --45
  elseif(colNumber<= 45 and colNumber>= 40) then
  return 45
  --50
  elseif(colNumber<= 50 and colNumber>= 45) then
  return 50
  --55
   elseif(colNumber<= 55 and colNumber>= 50) then
  return 55
  --60
  elseif(colNumber<= 60 and colNumber>= 55) then
  return 60
  --66
  elseif(colNumber<= 65 and colNumber>= 60) then
  return 66
  --75
  elseif(colNumber<= 75 and colNumber>= 65) then
  return 75
  --80
  elseif(colNumber<= 80 and colNumber>= 75) then
  return 80
  --85
  elseif(colNumber<= 85 and colNumber>= 80) then
  return 85
  --90
  elseif(colNumber<= 90 and colNumber>= 85) then
  return 90
  --100
  else
    return 100
  end
end

function cols(cols,type)
  local cols = to_array(cols)
  local cols_size = size(cols)
  local isColsCalulated = false
  local totalCols = 0
  for i = 1, cols_size do
    if(type==1) then
      if (cols[i]["@break"]) then
        io.write('<div class="w-100">')
      else
        io.write('<div class="col')
        if (cols[i]["@cols"]) then
          io.write('-'..cols[i]["@cols"])
        end
        if (cols[i]["@auto"]) then
          io.write('-md-auto')
        end
        if (cols[i]["@align"]) then
          io.write(' align-self-'..cols[i]["@align"])
        end
        io.write('">')
      end
      if (cols[i]:value()) then
        io.write(trim(cols[i]:value()))
      end
      io.write('</div>')
    end
    if(type==2) then
      if (cols[i]["@break"]) then
        io.write('</div><div class="column"></div><div class="row">')
      else
        io.write('<div class="column')
        if (cols[i]["@cols"]) then
          io.write(' column-'..miligramRound(math.floor((cols[i]["@cols"]*100/12)+0.5)))
        end
        if (cols[i]["@auto"]) then
          --io.write('-md-auto')
        end
        io.write('">')
        if (cols[i]:value()) then
          io.write(trim(cols[i]:value()))
        end
        io.write('</div>')
      end
    end
    if(type==3) then
      if(not isColsCalulated) then
        isColsCalulated = true
        for j = 1, cols_size do
          if (cols[j]["@cols"]) then
            totalCols = totalCols + cols[j]["@cols"]
          else
            totalCols = totalCols + 1
          end
          if (totalCols > 10) then
            totalCols = 10
          end
        end
      end
      if (cols[i]["@break"]) then
        io.write('</div><div class="uk-width-1-10"></div><div class="uk-grid uk-text-center uk-flex flex-container">')
      else
        if (cols[i]["@cols"]) then
          io.write('<div class="uk-width-1-'..cols_size)
          --io.write('<div class="uk-width-'..cols[i]["@cols"]..'-'..totalCols)
        else
          io.write('<div class="uk-width-1-'..cols_size)
        end
        if (cols[i]["@auto"]) then
          --io.write('-md-auto')
        end
        io.write('">')
        if (cols[i]:value()) then
          io.write(trim(cols[i]:value()))
        end
        io.write('</div>')
      end
    end 
  end
end

function rows(rows,type)
  local rows = to_array(rows)
  for i = 1, size(rows) do
    if(type==1) then 
      io.write('<div class="row')
      if (rows[i]["@cols"]) then
        io.write(' row-cols-'..rows[i]["@cols"])
      end
      if (rows[i]["@justify"]) then
        io.write(' justify-content-md-'..rows[i]["@justify"])
      end
      if (rows[i]["@align"]) then
        io.write(' align-items-'..rows[i]["@align"])
      end
      io.write('">')
    end
    if(type==2) then
      io.write('<div class="row')
      if (rows[i]["@justify"]) then
        io.write(' flex-container')
        if(rows[i]["@justify"]=='start') then
          io.write(' flex-start')
        end
        if(rows[i]["@justify"]=='center') then
          io.write(' flex-center')
        end
        if(rows[i]["@justify"]=='end') then
          io.write(' flex-end')
        end
        if(rows[i]["@justify"]=='around') then
          io.write(' flex-around')
        end
        if(rows[i]["@justify"]=='between') then
          io.write(' flex-between')
        end
      end
      io.write('">')
    end
    if(type==3)then
      io.write('<div class="uk-grid uk-text-center uk-flex flex-container')
      if (rows[i]["@cols"]) then
        io.write(' row-cols-'..rows[i]["@cols"])
      end
      if (rows[i]["@justify"]) then
        io.write(' uk-flex-')
        if(rows[i]["@justify"]=='start') then
          io.write('left')
        end
        if(rows[i]["@justify"]=='center') then
          io.write('center')
        end
        if(rows[i]["@justify"]=='end') then
          io.write('right')
        end
        if(rows[i]["@justify"]=='around') then
          io.write('around')
        end
        if(rows[i]["@justify"]=='between') then
          io.write('between')
        end
      end
      if (rows[i]["@align"]) then
        io.write(' align-items-'..rows[i]["@align"])
      end
      io.write('">')
    end 
    if (rows[i].col) then
      cols(rows[i].col,type)
    end
    io.write('</div>')
  end
end

function container(elem,type)
  if(type == 1) then
    if (elem["@fluid"]) then
      io.write('<div class="container-fluid">')
    else
      io.write('<div class="container">')
    end
  end
  if(type == 2) then
   io.write('<div class="container">')
 end
 if(type==3) then
  io.write('<div class="uk-container">')
end
if (elem.row) then
  rows(elem.row,type)
end
io.write('</div>')
end

function body(elem,type)
  io.write('<body>')
  if (elem.container) then
    container(elem.container,type)
  end
  io.write('</body>')
end

function head(elem,type)
  io.write('<head>')
  io.write('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />')
  io.write('<meta charset="utf-8" />')
  if (elem.title) then
    io.write('<title>'..elem.title:value()..'</title>')
  end
  if(type == 1) then
    io.write('<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">')
    io.write('<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">')
    io.write('<link rel="stylesheet" href="custom.css">')
  end
  if(type == 2) then 
    io.write('<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic">')
    io.write('<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css">')
    io.write('<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css">')
  end
  if(type == 3) then 
    io.write('<meta charset="utf-8">')
    io.write('<meta name="viewport" content="width=device-width, initial-scale=1">')
    io.write('<link rel="stylesheet" href="./uikit-3.16.14/css/uikit.min.css" />')
    io.write('<script src="./uikit-3.16.14/js/uikit.min.js"></script>')
    io.write('<script src="./uikit-3.16.14/js/uikit-icons.min.js"></script>')
  end
  if(type==2 or type==3) then
    io.write('<style>')
    io.write('.flex-container{display: flex;}')
    io.write('.flex-center{justify-content: center;}')
    io.write('.flex-start{justify-content: flex-start;}')
    io.write('.flex-end{justify-content: flex-end;}')
    io.write('.flex-around{justify-content: space-around;}')
    io.write('.flex-between{justify-content: space-between;}')
    io.write('</style>')
  end
  io.write('</head>')
end

function html(elem,type)
  io.write('<!doctype html>')
  io.write('<html lang="en">')
  if (elem.head) then
    head(elem.head,type)
  end
  if (elem.body) then
    body(elem.body,type)
  end
  io.write('</html>')
end

function main()
  local xml = newParser()
  for i = 1, 10 do
    local xhtml = 'grid'..i
    local type = 2
    local indexFile = assert(io.open(xhtml..'.xhtml', 'rb'))
    local content = indexFile:read('*all')
    local root = xml:ParseXmlText(content)
    if (root.html) then
    -- 1 = Bootstrap
    -- 2 = Miligram
    -- 3 = UiKit
    local route = ""
    if(type==1) then
      route = './html/bootstrap/'..xhtml..'.html'
    elseif(type==2)then
      route = './html/miligram/'..xhtml..'.html'
    elseif(type==3)then
      route = './html/uiKit/'..xhtml..'.html'
    end
    print('Processing '..xhtml..'...')
    if(string.len(route)>0)then
      file = io.open(route, "w+")
      io.output(file)
    end
    html(root.html,type)
    --file:close()
    io.close(file)
  end
end
end

main()
