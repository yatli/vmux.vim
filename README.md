# vmux.vim

Better window management for Vim.

### Features

- Sane window resize commands mimicking the `tmux` logic.
- Terminal layout management like `tmux`
- Buffer management like `tmux`
- Switch between buffers without caveats -- the buffers are categorized as `normal`, `terminal` and `other` and one category won't interfere with another.
  - example: switching buffer with `(vmux-buf-next)` in `NERDTree` or `help` has no effect.
  - example: switching buffer in a `terminal` moves to the next opened terminal, not a `normal` buffer.
- Kill buffers/terminals without interference.
- Split window. If splitting a terminal, spawn a new shell.
- Automatically setup terminal colors independent of color scheme.
- Automatically enter insert mode when entering a terminal buffer.
  - If the user previously leaves the terminal buffer in normal mode (i.e. scrolling), it does not start insert mode, and thus preserves scroll position.

### Installation

Use a plugin manager, for example [vim-plug](https://github.com/junegunn/vim-plug):
```vimL
"Dependencies
Plug 'qpkorr/vim-bufkill'
Plug 'kassio/neoterm'
" --------------------
Plug 'yatli/vmux.vim'
```

### Recommended bindings

The recommended bindings are enabled by default.
Use `let g:vmux_no_default_bindings = 1` to disable them.

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

" Show/hide terminals

imap <F11> <C-O><Plug>(vmux-term-toggle)
vmap <F11> <C-O><Plug>(vmux-term-toggle)
nmap <F11> <Plug>(vmux-term-toggle)
tmap <F11> <C-\><C-n><Plug>(vmux-term-toggle)

```

