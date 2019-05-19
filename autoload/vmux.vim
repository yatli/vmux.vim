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

" split_close ensures that the vim instance will not exit
" after the call. It's like the "do not close browser after
" closing the last tab" feature.
function! vmux#split_close()

    " for terminal we always hide it
    if &buftype == 'terminal'
        hide
        return
    endif

    " Checking the number of "solid" windows and see if I'm the last one with listed
    " buffer shown (rules out NERDTree, terminal, help etc.)
    " more than one buf window = safe
    " only one "solid" buf, or none: = tricky! only proceed if we are "not important".
    " if we are "solid", just kill the buffer
    " note: "solid" == "buflisted"

    if s:get_filebuf_win_count() > 1 || !&buflisted
        wincmd c
    else
        call vmux#buf_kill()
    endif

endfunction

function! vmux#buf_kill()
    " only kill if the buffer is a listed buffer
    " otherwise, either hide or close the window
    if &buflisted
        " https://github.com/neovim/neovim/issues/2434
        setl bufhidden=delete 
        if s:get_filebuf_count() > 1
            bnext
        else
            " tricky! if we "bdelete", the window will be closed.
            " if we "bnext", nothing happens.
            " so we force a "enew".
            enew!
        endif
    elseif &buftype == 'terminal'
        hide
    else
        " other non-listed buffers.
        " we assume there will never be a single non-listed buffer on screen.
        call vmux#split_close()
    endif
endfunction

function! vmux#buf_next()
    if &buflisted
        bnext
    elseif &buftype == 'terminal'
        call neoterm#next()
        startinsert
    else
        call vmux#split_close()
    endif
endfunction

function! vmux#buf_prev()
    if &buflisted
        bprev
    elseif &buftype == 'terminal'
        call neoterm#previous()
        startinsert
    else
        call vmux#split_close()
    endif
endfunction

function! vmux#term_setcolor()
    " focused term
    highlight Vmux           guibg=#000000 guifg=#EDEDED ctermbg=0 ctermfg=7
    " inactive cursor line
    highlight VmuxCursorLine guibg=#101010 guifg=#EDEDED ctermbg=9 ctermfg=7
    " inactive
    highlight VmuxNC         guibg=#101010 guifg=#EDEDED ctermbg=8 ctermfg=7
    " cursor
    highlight VmuxCursor     guibg=#ED3015 guifg=#000000 ctermbg=12 ctermfg=0
    highlight VmuxCursorNC   guibg=#404040 guifg=#EDEDED ctermbg=8 ctermfg=7

    " window-local highlight
    set winhighlight=Normal:Vmux,NonText:VmuxCursorLine,NormalNC:VmuxNC,CursorLine:VmuxCursorLine,TermCursor:VmuxCursor,TermCursorNC:VmuxCursorNC
    " disable the bright cursor line (I'm not sure how to set its color as of yet)
    " see: https://github.com/neovim/neovim/issues/2259
    setlocal nocursorline
    " set the terminal color scheme now
    " see: https://github.com/neovim/neovim/issues/4696
    " TODO match the console color scheme
    " let g:terminal_color_0 = 
endfunction

function! vmux#buf_add()
    if &previewwindow || &buftype == 'nofile' || &buftype == 'quickfix' 
        nnoremap <buffer> q :call vmux#split_close()<CR>
        setlocal nobuflisted
    endif
endfunction

function! vmux#buf_enter()
    if &buftype == 'terminal'
        startinsert
        call vmux#term_setcolor()
    elseif &buftype == 'nofile'
        " nothing
    endif
endfunction

function! vmux#buf_leave()
    " TODO nothing siginificant here atm
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
