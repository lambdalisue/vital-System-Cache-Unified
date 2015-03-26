"******************************************************************************
" A file based cache system which produce similar API as System.Cache.Simple
"
" Author:   Alisue <lambdalisue@cache_keynote.net>
" URL:      http://cache_keynote.net/
" License:  MIT license
" (C) 2015, Alisue, cache_keynote.net
"******************************************************************************
let s:save_cpo = &cpo
set cpo&vim

function! s:_vital_loaded(V) dict abort " {{{
  let s:V = a:V
  let s:File = a:V.import('System.File')
  let s:Path = a:V.import('System.Filepath')
  let s:Cache = a:V.import('System.Cache')
  let s:Base = a:V.import('System.Cache.Base')
endfunction " }}}
function! s:_vital_depends() abort " {{{
  return [
        \ 'System.File',
        \ 'System.Filepath',
        \ 'System.Cache',
        \ 'System.Cache.Base',
        \]
endfunction " }}}

let s:cache = {}
function! s:new(cache_dir) " {{{
  return extend(s:Base.new(),
        \ extend({ 'cache_dir': a:cache_dir }, deepcopy(s:cache))
        \)
endfunction " }}}

function! s:cache.has(name) abort " {{{
  let cache_key = self.cache_key(a:name)
  return s:Cache.filereadable(self.cache_dir, cache_key)
endfunction " }}}
function! s:cache.get(name, ...) abort " {{{
  let default = get(a:000, 0, '')
  let options = extend({ 'raw': 0 }, get(a:000, 1, {}))
  let cache_key = self.cache_key(a:name)
  let raw = s:Cache.readfile(self.cache_dir, cache_key)
  if empty(raw)
    return default
  endif
  if options.raw
    return raw
  else
    sandbox let obj = eval(raw[0])
    return obj
  endif
endfunction " }}}
function! s:cache.set(name, value, ...) abort " {{{
  let cache_key = self.cache_key(a:name)
  let options = extend({ 'raw': 0 }, get(a:000, 0, {}))
  if options.raw
    let value = a:value
  else
    let value = [string(a:value)]
  endif
  call s:Cache.writefile(self.cache_dir, cache_key, value)
endfunction " }}}
function! s:cache.remove(name) abort " {{{
  let cache_key = self.cache_key(a:name)
  if s:Cache.filereadable(self.cache_dir, cache_key)
    call s:Cache.deletefile(self.cache_dir, cache_key)
  endif
endfunction " }}}
function! s:cache.clear() abort " {{{
  call s:File.rmdir(self.cache_dir, 'r')
endfunction " }}}
function! s:cache.keys() abort " {{{
  let keys = split(glob(s:Path.join(self.cache_dir, '*'), 0), '\n')
  return map(keys, 'fnamemodify(v:val, ":t")')
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker
