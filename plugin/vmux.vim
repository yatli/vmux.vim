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

if !exists('g:vmux_no_default_bindings')

    " Quick window adjustment
    nnoremap <A-Up>    <Plug>(vmux-resize-up)
    nnoremap <A-Down>  <Plug>(vmux-resize-down)
    nnoremap <A-Left>  <Plug>(vmux-resize-left)
    nnoremap <A-Right> <Plug>(vmux-resize-right)

    tnoremap <A-Up>    <C-\><C-N><Plug>(vmux-resize-up)i
    tnoremap <A-Down>  <C-\><C-N><Plug>(vmux-resize-down)i
    tnoremap <A-Left>  <C-\><C-N><Plug>(vmux-resize-left)i
    tnoremap <A-Right> <C-\><C-N><Plug>(vmux-resize-right)i

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

    nnoremap <C-A-t> :tabnew<CR>
    nnoremap <C-A-q> :tabclose<CR>
    nnoremap <C-A-n> :tabnext<CR>
    nnoremap <C-A-p> :tabprevious<CR>

    " Quick buffer switch
    nnoremap <A-n> <Plug>(vmux-buf-next)
    nnoremap <A-p> <Plug>(vmux-buf-prev)
    nnoremap <A-w> <Plug>(vmux-buf-kill)
    tnoremap <A-n> <C-\><C-N><Plug>(vmux-buf-next)
    tnoremap <A-p> <C-\><C-N><Plug>(vmux-buf-prev)
    tnoremap <A-w> <C-\><C-N><Plug>(vmux-buf-kill)

    "Quick window split
    nnoremap <A-s> <Plug>(vmux-split-horizontal)
    nnoremap <A-v> <Plug>(vmux-split-vertical)
    nnoremap <A-q> <Plug>(vmux-split-close)

    tnoremap <A-s> <C-\><C-N><Plug>(vmux-split-horizontal)
    tnoremap <A-v> <C-\><C-N><Plug>(vmux-split-vertical)
    tnoremap <A-q> <C-\><C-N><Plug>(vmux-split-close)

    inoremap <F11> <C-O><Plug>(vmux-term-toggle)
    vnoremap <F11> <C-O><Plug>(vmux-term-toggle)
    nnoremap <F11> <Plug>(vmux-term-toggle)
    tnoremap <F11> <C-\><C-n><Plug>(vmux-term-toggle)

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
