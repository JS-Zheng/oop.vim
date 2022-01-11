function! oop#class#extend(class, base_class) abort
  if (!has_key(a:class, '__bases__'))
    let a:impl['__bases__'] = [a:base_class]
    return
  endif

  let ori_bases = a:class['__bases__']
  if (type(ori_bases) == v:t_dict)
    let a:impl['__bases__'] = [a:base_class, ori_bases]
  elseif(bases_type != v:t_list)
    throw "Illegal Argument"
  else
    call insert(ori_bases, a:base_class)
  endif
endfunction

function! oop#class#impl(class, method_name, Impl) abort
  let a:class[a:method_name] = a:Impl
endfunction

function! oop#class#super(class, method_name, args) abort
  let bases = a:class['__bases__']
  let bases_type = type(bases)
  if (bases_type == v:t_dict)
    let bases = [bases]
  elseif(bases_type != v:t_list)
    throw "Illegal Argument"
  endif

  for base in bases
    try
      return oop#class#call(base, a:method_name, a:args)
    catch /^Vim\%((\a\+)\)\=:E1\(1\|2\)7:/
    endtry
  endfor

  throw "Not Implemented"
endfunction

function! oop#class#call(class, method_name, args) abort
  let prefix = a:class['__name__']
  let Method = function(prefix . a:method_name)
  return call(Method, a:args)
endfunction

function! oop#class#new(class, args) abort
  try
    let obj = oop#class#call(a:class, '__new__', a:args)
  catch /^Vim\%((\a\+)\)\=:E117:/
    " Default Empty Constructor
    let obj = {'__class__': a:class}
  endtry
  if (oop#class#call(a:class, '__init__', [obj] + a:args) == 0)
    return obj
  endif
  throw "Init Object Failed"
endfunction

