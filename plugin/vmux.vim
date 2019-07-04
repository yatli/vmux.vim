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
    nmap <A-Up>    <Plug>(vmux-resize-up)
    nmap <A-Down>  <Plug>(vmux-resize-down)
    nmap <A-Left>  <Plug>(vmux-resize-left)
    nmap <A-Right> <Plug>(vmux-resize-right)

    tmap <A-Up>    <C-\><C-N><Plug>(vmux-resize-up)i
    tmap <A-Down>  <C-\><C-N><Plug>(vmux-resize-down)i
    tmap <A-Left>  <C-\><C-N><Plug>(vmux-resize-left)i
    tmap <A-Right> <C-\><C-N><Plug>(vmux-resize-right)i

    " Quick movement between windows
    " To use `ALT+{h,j,k,l}` to navigate windows from any mode: >
    tmap <A-h> <C-\><C-N><C-w>h
    tmap <A-j> <C-\><C-N><C-w>j
    tmap <A-k> <C-\><C-N><C-w>k
    tmap <A-l> <C-\><C-N><C-w>l

    imap <A-h> <C-O><C-w>h
    imap <A-j> <C-O><C-w>j
    imap <A-k> <C-O><C-w>k
    imap <A-l> <C-O><C-w>l

    nmap <A-h> <C-w>h
    nmap <A-j> <C-w>j
    nmap <A-k> <C-w>k
    nmap <A-l> <C-w>l

    nmap <C-A-h> <C-w>H
    nmap <C-A-j> <C-w>J
    nmap <C-A-k> <C-w>K
    nmap <C-A-l> <C-w>L

    nmap <C-A-t> :tabnew<CR>
    nmap <C-A-q> :tabclose<CR>
    nmap <C-A-n> :tabnext<CR>
    nmap <C-A-p> :tabprevious<CR>

    " Quick buffer switch
    nmap <A-n> <Plug>(vmux-buf-next)
    nmap <A-p> <Plug>(vmux-buf-prev)
    nmap <A-w> <Plug>(vmux-buf-kill)
    tmap <A-n> <C-\><C-N><Plug>(vmux-buf-next)
    tmap <A-p> <C-\><C-N><Plug>(vmux-buf-prev)
    tmap <A-w> <C-\><C-N><Plug>(vmux-buf-kill)

    " Quick window split
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

    tmap <PageUp> <C-\><C-n><PageUp>
    tmap <PageDown> <C-\><C-n><PageDown>
    tmap <expr> <A-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
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
