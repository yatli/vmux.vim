# vmux.vim

Better window management for Vim.

### Features

- Sane window resize commands mimicking the `tmux` logic.
- Switch between buffers without caveats -- the buffers are categorized as `normal`, `terminal` and `other` and one category won't interfere with another.
- Again: kill buffers/terminals without interference.
- Split window. If splitting a terminal, spawn a new shell.
- Automatically setup terminal colors independent of color scheme.
- Automatically enter insert mode when entering a terminal buffer.

### Installation

Use a plugin manager, for example [vim-plug](https://github.com/junegunn/vim-plug):
```
plug 'yatli/vmux.vim'
```

### Recommended bindings

```vimL
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
```
