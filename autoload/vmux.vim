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
    if &buftype == ''
        wincmd s
    elseif &buftype == 'terminal'
        belowright Tnew
    else
        bdelete
    endif
endfunction

function! vmux#split_v()
    if &buftype == ''
        wincmd v
    elseif &buftype == 'terminal'
        vertical Tnew
    else
        bdelete
    endif
endfunction

function! s:get_filebuf_win_count()
    " Iterate through the windows and see if I'm the last one with listed
    " buffer shown (rules out NERDTree, terminal, help etc.)
    let winid  = winnr('$')
    let listed = 0

    while winid > 0
        let win_bufnr = winbufnr(winid)
        if buflisted(win_bufnr)
            let listed = listed + 1
        endif
        let winid = winid - 1
    endwhile
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

    " more than one buf = safe
    " only one "solid" buf, or none: = tricky! only proceed if we are "not important".
    " if we are important, just kill the buffer

    if s:get_filebuf_win_count() > 1
        wincmd c
    elseif &buflisted && bufname('%') != ''
        " tricky! 
        bdelete
    elseif &buflisted && bufname('%') == ''
        " I'm the last "solid" window but it's a [NO NAME] buffer
        " do nothing
    else
        wincmd c
    endif

endfunction

function! vmux#buf_kill()
    " only kill if the buffer is a listed buffer
    " otherwise, either hide or close the window
    if &buflisted && bufname('%') != ''
        BD
    elseif &buflisted && bufname('%' == '')
        " do nothing
    elseif &buftype == 'terminal'
        hide
    else
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

function! vmux#buf_enter()
    if &buftype == 'terminal'
        startinsert
        call vmux#term_setcolor()
    elseif &buftype == 'nofile'
        " TODO kill the buffer
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
