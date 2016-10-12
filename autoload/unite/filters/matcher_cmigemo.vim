
let s:matcher = {
      \ 'name' : 'matcher_cmigemo',
      \ 'description' : 'migemo matcher',
      \}


function! s:matcher.filter(candidates, context) abort "{{{
  let candidates = a:candidates

  if empty(a:context.input_list)
    return candidates
  endif

  call unite#filters#matcher_cmigemo#_update_dict_param()

  for input in a:context.input_list
    let expr = 'v:val.word =~ ' . string(self.pattern(input))
    try
      let candidates = unite#filters#filter_matcher(candidates, expr, a:context)
    catch
      let candidates = []
    endtry
  endfor
  return candidates
endfunction "}}}


function! s:matcher.pattern(input) abort "{{{
  let cmdln = 'cmigemo --vim --nonewline --word "' . a:input . '" '
        \ . s:cmigemo_dict_param_str
  return unite#util#system(cmdln)
endfunction "}}}


function! unite#filters#matcher_cmigemo#_update_dict_param() abort "{{{
  let dicts = get(b:, 'unite_matcher_cmigemo_dicts', get(g:, 'unite_matcher_cmigemo_dicts', [get(g:, 'migemodict', '')]))
  if empty(dicts)
    echoerr 'vim-unite-filter-matcher_cmigemo: require g:unite_matcher_cmigemo_dicts or g:migemodict.'
  endif
  let s:cmigemo_dict_param_str = ' --dict "' . dicts[0] . '"'
  for subdict in dicts[1:]
    let s:cmigemo_dict_param_str .= ' --subdict "' . subdict . '"'
  endfor
endfunction "}}}


function! unite#filters#matcher_cmigemo#define() abort "{{{
  return s:matcher
endfunction "}}}
