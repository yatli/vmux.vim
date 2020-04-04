" window neighbor detection function
" return 1 on the presense of a window to the given direction from the current
" window. direction can be one of the following:
" - 'up'
" - 'down'
" - 'left'
" - 'right'
function! s:has_neighbor(direction)
    let currentposition = win_screenpos(winnr())
    let currentsize     = [winheight(0), winwidth(0)]

    "echo 'my position: ' . string(currentposition)
    "echo 'my size:     ' . string(currentsize)

    let winid = winnr('$')

    while winid > 0
        let winpos = win_screenpos(winid)
        "echo 'win #' . string(winid) . ':  ' . string(winpos)

        if a:direction == 'up' && currentposition[0] > winpos[0]
            return 1
        elseif a:direction == 'left' && currentposition[1] > winpos[1]
            return 1
        elseif a:direction == 'right' && winpos[1] >= currentposition[1] + currentsize[1]
            return 1
        elseif a:direction == 'down' && winpos[0] >= currentposition[0] + currentsize[0]
            return 1
        else
            let winid = winid - 1
        endif
    endwhile
    return 0
endfunction

" window adjustment functions

" increase size if not bottom
function! vmux#window_pushdown()
    if s:has_neighbor('down')
        wincmd +
    else
        wincmd -
    endif
endfunction

" decrease size if not bottom
function! vmux#window_pushup()
    if s:has_neighbor('down')
        wincmd -
    else
        wincmd +
    endif
endfunction

" decrease size if not rightmost
function! vmux#window_pushleft()
    if s:has_neighbor('right')
        wincmd <
    else
        wincmd >
    endif
endfunction

" increase size if not rightmost
function! vmux#window_pushright()
    if s:has_neighbor('right')
        wincmd >
    else
        wincmd <
    endif
endfunction

function! vmux#split_h()
    if &buftype == 'terminal'
        belowright Tnew
    else
        wincmd s
    endif
endfunction

function! vmux#split_v()
    if &buftype == 'terminal'
        vertical Tnew
    else
        wincmd v
    endif
endfunction

function! s:get_filebuf_win_count()
    let winid  = winnr('$')
    let listed = 0

    while winid > 0
        let win_bufnr = winbufnr(winid)
        if buflisted(win_bufnr)
            let listed = listed + 1
        endif
        let winid = winid - 1
    endwhile
    return listed
endfunction

function! s:get_filebuf_count()
    let bufid  = bufnr('$')
    let listed = 0

    while bufid > 0
        if buflisted(bufid)
            let listed = listed + 1
        endif
        let bufid = bufid - 1
    endwhile
    return listed
endfunction

if !exists("g:vmux_tab_buf_map")
    let g:vmux_tab_buf_map = {}
endif

if !exists("g:vmux_term_modes")
    let g:vmux_term_modes = {}
endif

function! s:ensure_tabmap()
    " see: https://vi.stackexchange.com/questions/4091/how-to-bind-a-set-of-buffers-to-a-tab
    let tabid = tabpagenr()

    if !has_key(g:vmux_tab_buf_map, tabid)
        let g:vmux_tab_buf_map[tabid] = []
    endif
    return g:vmux_tab_buf_map[tabid]
endfunction


" split_close ensures that the vim instance will not exit
" after the call. It's like the "do not close browser after
" closing the last tab" feature.
function! vmux#split_close()

    let fbcnt  = s:get_filebuf_count()
    let wincnt = winnr('$')

    " Checking the number of "solid" windows and see if I'm the last one with listed
    " buffer shown (rules out NERDTree, terminal, help etc.)
    " more than one buf window = safe
    " only one "solid" buf, or none: = tricky! only proceed if we are "not important".
    " if we are "solid", just kill the buffer
    " note: "solid" == "buflisted"

    if s:get_filebuf_win_count() > 1 || (!&buflisted && wincnt > 1)
        " for terminal we always try to hide it
        if &buftype == 'terminal'
            hide
        else
            wincmd c
        endif
    else
        " only one split left, do nothing
        return
    endif

endfunction

function! vmux#buf_kill()
    " only kill if the buffer is a listed buffer
    " otherwise, either hide or close the window

    let fbcnt  = s:get_filebuf_count()
    let wincnt = winnr('$')
    let bufid = bufnr('%')
    let winid = winnr()

    if &buflisted
        " https://github.com/neovim/neovim/issues/2434
        setlocal bufhidden=delete 
        if fbcnt > 1
            " tricky! if the buffer is currently being displayed in another window, bnext doesn't kill
            " let's bnext all the instances then
            while wincnt > 0
                if winbufnr(wincnt) == bufid
                    execute wincnt . "wincmd w"
                    call vmux#buf_next()
                endif
                let wincnt = wincnt - 1
            endwhile
        else
            " tricky! if we "bdelete", the window will be closed.
            " if we "bnext", nothing happens.
            " so we force a "enew".
            while wincnt > 0
                if winbufnr(wincnt) == bufid
                    execute wincnt . "wincmd w"
                    enew!
                endif
                let wincnt = wincnt - 1
            endwhile
        endif
        execute winid . "wincmd w"
    elseif &buftype == 'terminal'
        if wincnt > 1
            hide
        else
            " tricky! we cannot close the last window
            return
        endif
    else
        " other non-listed buffers.
        if fbcnt > 0
            bdelete
        else
            call vmux#split_close()
        endif
    endif
endfunction

function! vmux#buf_next()
    if &buflisted
        let tabmap = s:ensure_tabmap()
        let tabmaplen = len(tabmap)
        if tabmaplen == 0
            return
        endif
        let bufid = bufnr("%")
        let bufidx = index(tabmap, bufid)
        if bufidx < 0
            echo "vmux#buf_next(): bufid " . bufid . " not found, tabmap: " . string(tabmap)
            let bufidx = 0
        endif
        let bufidx = (bufidx+1) % tabmaplen
        execute "b " . tabmap[bufidx]
    elseif &buftype == 'terminal'
        call neoterm#next()
        startinsert
    else
        call vmux#split_close()
    endif
endfunction

function! vmux#buf_prev()
    if &buflisted
        let tabmap = s:ensure_tabmap()
        let tabmaplen = len(tabmap)
        if tabmaplen == 0
            return
        endif
        let bufid = bufnr("%")
        let bufidx = index(tabmap, bufid)
        if bufidx < 0
            echo "vmux#buf_prev(): bufid " . bufid . " not found, tabmap: " . string(tabmap)
            let bufidx = 0
        endif
        let bufidx = (bufidx-1+tabmaplen) % tabmaplen
        execute "b " . tabmap[bufidx]
    elseif &buftype == 'terminal'
        call neoterm#previous()
        startinsert
    else
        call vmux#split_close()
    endif
endfunction

function! vmux#term_setcolor()
    " TODO sometimes the native colorscheme works just well enough and we don't
    " have to patch it... find out the certificate

    " focused term
    "highlight Vmux           guibg=#000000 guifg=#EDEDED ctermbg=0 ctermfg=7
    " inactive cursor line
    "highlight VmuxCursorLine guibg=#101010 guifg=#EDEDED ctermbg=9 ctermfg=7
    " inactive
    "highlight VmuxNC         guibg=#101010 guifg=#EDEDED ctermbg=8 ctermfg=7
    " cursor
    "highlight VmuxCursor     guibg=#ED3015 guifg=#000000 ctermbg=12 ctermfg=0
    "highlight VmuxCursorNC   guibg=#404040 guifg=#EDEDED ctermbg=8 ctermfg=7

    " window-local highlight
    "set winhighlight=Normal:Vmux,NonText:VmuxCursorLine,NormalNC:VmuxNC,CursorLine:VmuxCursorLine,TermCursor:VmuxCursor,TermCursorNC:VmuxCursorNC

    " disable the bright cursor line (I'm not sure how to set its color as of yet)
    " see: https://github.com/neovim/neovim/issues/2259
    setlocal nocursorline
    " hotfix the terminal color scheme
    " see: https://github.com/neovim/neovim/issues/4696
    " let g:terminal_color_0 = 
endfunction

function! vmux#buf_delete(bufid)
    let tabmap = s:ensure_tabmap()

    let bufid = str2nr(a:bufid)
    let bufidx = index(tabmap, bufid)
    if bufidx >= 0
        call remove(tabmap, bufidx)
    endif
endfunction

function! vmux#buf_add(bufid)
    if &previewwindow || &buftype == 'nofile' || &buftype == 'quickfix'  || &buftype == 'help'
        nnoremap <buffer> q :call vmux#split_close()<CR>
        setlocal nobuflisted
        return
    endif

    let tabmap = s:ensure_tabmap()
    let bufid = str2nr(a:bufid)
    if index(tabmap, bufid) < 0
        let szmap = len(tabmap)
        let inspos = 0
        while inspos < szmap && tabmap[inspos] < bufid
            let inspos = inspos + 1
        endwhile
        let g:vmux_tab_buf_map[tabpagenr()] = insert(tabmap, bufid, inspos)
    endif
endfunction

function! vmux#buf_enter()
  let bufid = bufnr('%')
  if &buftype == 'terminal'
    if !has_key(g:vmux_term_modes, bufid)
      g:vmux_term_modes[bufid] = 'i'
    endif

    if g:vmux_term_modes[bufid] == 'i'
      startinsert
    endif
    call vmux#term_setcolor()
  elseif &buftype == 'nofile'
    call vmux#buf_add(bufid)
  elseif &buflisted
    call vmux#buf_add(bufid)
    stopinsert
  endif
endfunction

function! vmux#buf_leave()
  if &buftype == 'terminal'
    " condition 1: cursor is at the last line
    " condition 2: the buffer is not long enough to fill the whole window,
    " and therefore if exiting from insert mode, it's impossible that the
    " cursor is placed at the last line of the buffer.
    let ll = line('$')
    let cl = line('.')
    let h = winheight('%')
    let m = (ll <= h || cl == ll) ?  'i' : 'n'
    let g:vmux_term_modes[bufnr('%')] = m
  endif
endfunction

function! vmux#term_open()
    setlocal nobuflisted
    call vmux#term_setcolor()
endfunction

function! vmux#term_toggle()
    if g:neoterm.has_any()
        TtoggleAll
    else
        below Ttoggle
    endif
endfunction
