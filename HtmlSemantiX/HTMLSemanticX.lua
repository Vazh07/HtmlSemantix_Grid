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

function cols(cols)
  cols = to_array(cols)
  for i = 1, size(cols) do
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
      if (cols[i]:value()) then
        io.write(trim(cols[i]:value()))
      end
    end
    io.write('</div>')
  end
end

function rows(rows)
  rows = to_array(rows)
  for i = 1, size(rows) do
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
    if (rows[i].col) then
      cols(rows[i].col)
    end
    io.write('</div>')
  end
end

function container(elem)
  if (elem["@fluid"]) then
    io.write('<div class="container-fluid">')
  else
    io.write('<div class="container">')
  end
  if (elem.row) then
    rows(elem.row)
  end
  io.write('</div>')
end

function body(elem)
  io.write('<body>')
  if (elem.container) then
    container(elem.container)
  end
  io.write('</body>')
end

function head(elem)
  io.write('<head>')
  io.write('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />')
  io.write('<meta charset="utf-8" />')
  if (elem.title) then
    io.write('<title>'..elem.title:value()..'</title>')
  end
  io.write('<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">')
  io.write('<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">')
  io.write('<link rel="stylesheet" href="custom.css">')
  io.write('</head>')
end

function html(elem)
  io.write('<!doctype html>')
  io.write('<html lang="en">')
  if (elem.head) then
    head(elem.head)
  end
  if (elem.body) then
    body(elem.body)
  end
  io.write('</html>')
end

function main()
  local xml = require('xmlSimple').newParser()
  local indexFile = assert(io.open('grid8.xhtml', 'rb'))
  local content = indexFile:read('*all')
  local root = xml:ParseXmlText(content)
  if (root.html) then
    html(root.html)
  end
end

main()
