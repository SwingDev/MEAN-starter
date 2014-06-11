exports.getAttrByString = (o, s) ->
  s = s.replace(/\[(\w+)\]/g, ".$1") # convert indexes to properties
  s = s.replace(/^\./, "") # strip a leading dot
  a = s.split(".")
  while a.length
    n = a.shift()
    if n of o
      o = o[n]
    else
      return
  return o
