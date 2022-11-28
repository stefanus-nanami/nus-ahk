;;
;; An autohotkey script that provides emacs-like keybinding on Windows.
;; Use F13 to toggle.
;;

#InstallKeybdHook
#UseHook

;; The following line is a contribution of NTEmacs wiki.
;; http://www49.atwiki.jp/ntemacs/pages/20.html
SetKeyDelay 0

;; Enable regex for ahk_class and ahk_exe.
SetTitleMatchMode, RegEx

;; Turns to be 1 when ctrl-x is pressed.
is_c_x = 0
;; Turns to be 1 when ctrl-space is pressed.
is_c_spc = 0

;; Disable emacs keys
is_disabled = 1

;; Display splash text with transparent BG.
splash_text(message)
{
  Gui, +AlwaysOnTop +Disabled -SysMenu -Caption +Owner ;; +Owner avoids a taskbar button.
  Gui, Color, Gray
  Gui +LastFound
  WinSet, TransColor, Gray
  Gui, Font, cSilver s24
  Gui, Add, Text , , %message%
  Gui, Show, Center NoActivate ;; NoActivate avoids deactivating the currently active window.
  Sleep 512
  Gui, Destroy
}

reset_states()
{
  global
  is_c_x = 0
  is_c_spc = 0
}

disable_emacs_keys()
{
  ;; Disable splash.
  splash_text("EmacsKeys Disabled")
  global is_disabled = 1
  reset_states()
}

enable_emacs_keys()
{
  ;; Enable splash.
  splash_text("EmacsKeys Enabled")
  global is_disabled = 0
  reset_states()
}

;; Disable emacs-like keybindings.
passthrough()
{
  global
  If is_disabled
    Return 1

  IfWinActive, ahk_class ConsoleWindowClass ;; Windows terminals
    Return 1 
  IfWinActive, ahk_class Emacs ;; NTEmacs
    Return 1
  IfWinActive, ahk_class mintty ;; Cygwin/GitBash
    Return 1
  IfWinActive, ahk_class CASCADIA_HOSTING_WINDOW_CLASS ;; Windows terminals
    Return 1
  IfWinActive, ahk_exe i)\\xyzzy\.exe$ ;; xyzzy
    Return 1
  IfWinActive, ahk_exe i)\\switcheroo\.exe$ ;; Switcheroo
    Return 1 

  Return 0
}

delete_char()
{
  Send {Del}
  global is_c_spc = 0
}

kill_word()
{
  Send {CtrlDown}{ShiftDown}{Right}{ShiftUp}x{CtrlUp}
  global is_c_spc = 0
}

delete_backward_char()
{
  Send {BS}
  global is_c_spc = 0
}

kill_line()
{
  Send {ShiftDown}{END}{ShiftUp}
  Send ^x
  global is_c_spc = 0
}

open_line()
{
  Send {END}{Enter}{Up}
  global is_c_spc = 0
}

quit()
{
  Send {ESC}
  reset_states()
}

newline()
{
  Send {Enter}
  global is_c_spc = 0
}

indent_for_tab_command()
{
  Send {Tab}
  global is_c_spc = 0
}

newline_and_indent()
{
  Send {Enter}{Tab}
  global is_c_spc = 0
}

isearch_forward()
{
  Send ^f
  global is_c_spc = 0
}

isearch_backward()
{
  Send +{F3}
  global is_c_spc = 0
}

kill_region()
{
  Send ^x
  global is_c_spc = 0
}

kill_ring_save()
{
  Send ^c
  global is_c_spc = 0
}

yank()
{
  Send ^v
  global is_c_spc = 0
}

undo()
{
  Send ^z
  global is_c_spc = 0
}

redo()
{
  Send +^z
  global is_c_spc = 0
}

find_file()
{
  Send ^o
  global is_c_x = 0
}

save_buffer()
{
  Send, ^s
  global is_c_x = 0
}

kill_app()
{
  Send !{F4}
  global is_c_x = 0
}

kill_buffer()
{
  Send ^{F4}
  global is_c_x = 0
}

move_beginning_of_line()
{
  global
  If is_c_spc
    Send +{HOME}
  Else
    Send {HOME}
}

move_end_of_line()
{
  global
  If is_c_spc
    Send +{END}
  Else
    Send {END}
}

previous_line()
{
  global
  If is_c_spc
    Send +{Up}
  Else
    Send {Up}
}

next_line()
{
  global
  If is_c_spc
    Send +{Down}
  Else
    Send {Down}
}

forward_char()
{
  global
  If is_c_spc
    Send +{Right}
  Else
    Send {Right}
}

backward_char()
{
  global
  If is_c_spc
    Send +{Left} 
  Else
    Send {Left}
}

forward_word()
{
  global
  If is_c_spc
    Send ^+{Right}
  Else
    Send ^{Right}
}

backward_word()
{
  global
  If is_c_spc
    Send ^+{Left} 
  Else
    Send ^{Left}
}

scroll_up()
{
  global
  If is_c_spc
    Send +{PgUp}
  Else
    Send {PgUp}
}

scroll_down()
{
  global
  If is_c_spc
    Send +{PgDn}
  Else
    Send {PgDn}
}

select_all()
{
  Send ^a
  global is_c_spc = 1
}

send_unmodified(key)
{
  Send %key%
  reset_states()
}

start_of_buffer()
{
  global
  If is_c_spc
    Send ^+{Home}
  Else
    Send ^{Home}
}

end_of_buffer()
{
  global
  If is_c_spc
    Send ^+{End}
  Else
    Send ^{End}
}



F13::
  If is_disabled
    enable_emacs_keys()
  Else
    disable_emacs_keys()
  Return

^x::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    is_c_x = 1
  Return 

^f::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
  {
    If is_c_x
      find_file()
    Else
      forward_char()
  }
  Return  

^c::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
  {
    If is_c_x
      kill_app()
  }
  Return  

k::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    If is_c_x
      kill_buffer()
    Else
      send_unmodified(A_ThisHotkey)
  Return

^d::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    delete_char()
  Return

;;^h::
;;  If passthrough()
;;    send_unmodified(A_ThisHotkey)
;;  Else
;;    delete_backward_char()
;;  Return

^k::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    kill_line()
  Return

;; ^o::
;;   If passthrough()
;;     send_unmodified(A_ThisHotkey)
;;   Else
;;     open_line()
;;   Return

^g::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    quit()
  Return

;; ^j::
;;   If passthrough()
;;     send_unmodified(A_ThisHotkey)
;;   Else
;;     newline_and_indent()
;;   Return

^m::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    newline()
  Return

;;^i::
;;  If passthrough()
;;    send_unmodified(A_ThisHotkey)
;;  Else
;;    indent_for_tab_command()
;;  Return

^s::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
  {
    If is_c_x
      save_buffer()
    Else
      isearch_forward()
  }
  Return

;;^r::
;;  If passthrough()
;;    send_unmodified(A_ThisHotkey)
;;  Else
;;    isearch_backward()
;;  Return

^w::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    kill_region()
  Return

!w::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    kill_ring_save()
  Return

^y::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    yank()
  Return

^\::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    undo()
  Return  

+^\::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    redo()
  Return  

^vk20::
  If passthrough()
    Send {CtrlDown}{Space}{CtrlUp}
  Else
  {
    If is_c_spc
      is_c_spc = 0
    Else
      is_c_spc = 1
  }
  Return

^@::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
  {
    If is_c_spc
      is_c_spc = 0
    Else
      is_c_spc = 1
  }
  Return

^a::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    move_beginning_of_line()
  Return

^e::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    move_end_of_line()
  Return

^p::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    previous_line()
  Return

^n::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    next_line()
  Return

^b::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    backward_char()
  Return

^v::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    scroll_down()
  Return

!v::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    scroll_up()
  Return

!a::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    select_all()
  Return

!f::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    forward_word()
  Return

!b::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    backward_word()
  Return

!d::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    kill_word()
  Return

!>::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    end_of_buffer()
  Return

!<::
  If passthrough()
    send_unmodified(A_ThisHotkey)
  Else
    start_of_buffer()
  Return
