" better window management

if exists('g:vmux_init')
    finish
endif

" <Plug> mappings
noremap <Plug>(vmux-resize-up)        :call vmux#window_pushup()<CR>
noremap <Plug>(vmux-resize-down)      :call vmux#window_pushdown()<CR>
noremap <Plug>(vmux-resize-left)      :call vmux#window_pushleft()<CR>
noremap <Plug>(vmux-resize-right)     :call vmux#window_pushright()<CR>
noremap <Plug>(vmux-buf-next)         :call vmux#buf_next()<CR>
noremap <Plug>(vmux-buf-prev)         :call vmux#buf_prev()<CR>
noremap <Plug>(vmux-buf-kill)         :call vmux#buf_kill()<CR>
noremap <Plug>(vmux-split-horizontal) :call vmux#split_h()<CR>
noremap <Plug>(vmux-split-vertical)   :call vmux#split_v()<CR>
noremap <Plug>(vmux-split-close)      :call vmux#split_close()<CR>
noremap <Plug>(vmux-term-toggle)      :call vmux#term_toggle()<CR>

function! s:key_available(name)
    return (maparg(a:name) == "")
endfunction

let s:arrows_available =
            \ s:key_available("<A-Up>") &&
            \ s:key_available("<A-Down>") &&
            \ s:key_available("<A-Left>") &&
            \ s:key_available("<A-Right>")

if !exists('g:vmux_no_default_bindings') && s:arrows_available

    " Quick window adjustment
    nmap <A-Up>    <Plug>(vmux-resize-up)
    nmap <A-Down>  <Plug>(vmux-resize-down)
    nmap <A-Left>  <Plug>(vmux-resize-left)
    nmap <A-Right> <Plug>(vmux-resize-right)

    tmap <A-Up>    <C-\><C-N><Plug>(vmux-resize-up)i
    tmap <A-Down>  <C-\><C-N><Plug>(vmux-resize-down)i
    tmap <A-Left>  <C-\><C-N><Plug>(vmux-resize-left)i
    tmap <A-Right> <C-\><C-N><Plug>(vmux-resize-right)i

endif

let s:hjkl_available =
            \ s:key_available("<A-h>") &&
            \ s:key_available("<A-j>") &&
            \ s:key_available("<A-k>") &&
            \ s:key_available("<A-l>") &&
            \ s:key_available("<C-A-h>") &&
            \ s:key_available("<C-A-j>") &&
            \ s:key_available("<C-A-k>") &&
            \ s:key_available("<C-A-l>")

if !exists('g:vmux_no_default_bindings') && s:hjkl_available

    " Quick movement between windows
    " To use `ALT+{h,j,k,l}` to navigate windows from any mode: >
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l

    inoremap <A-h> <C-O><C-w>h
    inoremap <A-j> <C-O><C-w>j
    inoremap <A-k> <C-O><C-w>k
    inoremap <A-l> <C-O><C-w>l

    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l

    nnoremap <C-A-h> <C-w>H
    nnoremap <C-A-j> <C-w>J
    nnoremap <C-A-k> <C-w>K
    nnoremap <C-A-l> <C-w>L

endif

let s:tqnpwsv_available =
            \ s:key_available("<A-t>") &&
            \ s:key_available("<A-q>") &&
            \ s:key_available("<A-n>") &&
            \ s:key_available("<A-p>") &&
            \ s:key_available("<A-w>") &&
            \ s:key_available("<A-s>") &&
            \ s:key_available("<A-v>")

if !exists('g:vmux_no_default_bindings') && s:tqnpwsv_available

    nnoremap <C-A-t> :tabnew<CR>
    nnoremap <C-A-q> :tabclose<CR>
    nnoremap <C-A-n> :tabnext<CR>
    nnoremap <C-A-p> :tabprevious<CR>

    " Quick buffer switch
    nmap <A-n> <Plug>(vmux-buf-next)
    nmap <A-p> <Plug>(vmux-buf-prev)
    nmap <A-w> <Plug>(vmux-buf-kill)
    tmap <A-n> <C-\><C-N><Plug>(vmux-buf-next)
    tmap <A-p> <C-\><C-N><Plug>(vmux-buf-prev)
    tmap <A-w> <C-\><C-N><Plug>(vmux-buf-kill)

    "Quick window split
    nmap <A-s> <Plug>(vmux-split-horizontal)
    nmap <A-v> <Plug>(vmux-split-vertical)
    nmap <A-q> <Plug>(vmux-split-close)

    tmap <A-s> <C-\><C-N><Plug>(vmux-split-horizontal)
    tmap <A-v> <C-\><C-N><Plug>(vmux-split-vertical)
    tmap <A-q> <C-\><C-N><Plug>(vmux-split-close)

    imap <F11> <C-O><Plug>(vmux-term-toggle)
    vmap <F11> <C-O><Plug>(vmux-term-toggle)
    nmap <F11> <Plug>(vmux-term-toggle)
    tmap <F11> <C-\><C-n><Plug>(vmux-term-toggle)

    tnoremap <PageUp> <C-\><C-n><PageUp>
    tnoremap <PageDown> <C-\><C-n><PageDown>
    tnoremap <expr> <A-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif

augroup VmuxVim
    autocmd TermOpen  * call vmux#term_open()
    autocmd BufEnter  * call vmux#buf_enter()
    autocmd BufAdd    * call vmux#buf_add(expand('<abuf>'))
    autocmd BufDelete * call vmux#buf_delete(expand('<abuf>'))
    autocmd BufLeave  * call vmux#buf_leave()
    autocmd FileType help,qf call vmux#buf_add('-1') 
augroup end

let g:vmux_init = 1
