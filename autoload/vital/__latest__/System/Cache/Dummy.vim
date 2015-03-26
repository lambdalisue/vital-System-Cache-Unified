"******************************************************************************
" A dummy cache system which API is similar to System.Cache.Simple
"
" Author:   Alisue <lambdalisue@cache_keynote.net>
" URL:      http://cache_keynote.net/
" License:  MIT license
" (C) 2014, Alisue, cache_keynote.net
"******************************************************************************
let s:save_cpo = &cpo
set cpo&vim

function! s:_vital_loaded(V) dict abort " {{{
  let s:Base = a:V.import('System.Cache.Base')
endfunction " }}}
function! s:_vital_depends() abort " {{{
  return ['System.Cache.Base']
endfunction " }}}

let s:cache = {}
function! s:new() " {{{
  return extend(s:Base.new(), deepcopy(s:cache))
endfunction " }}}

function! s:cache.has(name) dict " {{{
  return 0
endfunction " }}}
function! s:cache.get(name, ...) dict " {{{
  return get(a:000, 0, '')
endfunction " }}}
function! s:cache.set(name, value) dict " {{{
  " do nothing
endfunction " }}}
function! s:cache.keys() dict " {{{
  return []
endfunction " }}}
function! s:cache.remove(name) dict " {{{
  " do nothing
endfunction " }}}
function! s:cache.clear() dict " {{{
  " do nothing
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker
