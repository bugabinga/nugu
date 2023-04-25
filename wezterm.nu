use palette.nu

def brighten [ mode:string ] {
  if $mode == "dark" {
    pastel lighten 0.1 | pastel desaturate 0.1 | pastel format hex | str trim
  } else  {
   pastel darken 0.1 | pastel desaturate 0.1 | pastel format hex | str trim 
  }
}

def wezterm_theme [ mode:string ] {
  let nugu = ( palette nugu $mode )
  let black = $nugu.palette.content.normal
  let red = $nugu.palette.error
  let green = $nugu.palette.info
  let yellow = $nugu.palette.warning
  let blue = $nugu.palette.content.important_local
  let magenta = $nugu.palette.content.accent
  let cyan = $nugu.palette.content.focus
  let white = $nugu.palette.content.minor

  $"{
    -- The default text color
    foreground = '($nugu.palette.ui.normal)',
    -- The default background color
    background = '($nugu.palette.ui.backdrop)',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '($nugu.palette.ui.accent)',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '($nugu.palette.ui.important_global)',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '($nugu.palette.ui.accent)',

    -- the foreground color of selected text
    selection_fg = '($nugu.palette.ui.important_local)',
    -- the background color of selected text
    selection_bg = '($nugu.palette.ui.focus)',

    -- The color of the scrollbar 'thumb'; the portion that represents the current viewport
    scrollbar_thumb = '($nugu.palette.ui.unfocus)',

    -- The color of the split lines between panes
    split = '($nugu.palette.ui.unfocus)',

    ansi = {
      '($black)', -- black
      '($red)', -- red
      '($green)', -- green
      '($yellow)', -- yellow
      '($blue)', -- blue
      '($magenta)', -- magenta
      '($cyan)', -- cyan
      '($white)', -- white
    },

    brights = {
      '($black | brighten $mode)',
      '($red | brighten $mode)',
      '($green | brighten $mode)',
      '($yellow | brighten $mode)',
      '($blue | brighten $mode)',
      '($magenta | brighten $mode)',
      '($cyan | brighten $mode)',
      '($white | brighten $mode)',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '($nugu.palette.ui.focus)',
    visual_bell = '($nugu.palette.ui.important_global)',
  }"
}

export def theme [] {
  $"return {
    ['nugu-dark'] = (wezterm_theme dark),
    ['nugu-light'] = (wezterm_theme light),
  }"
}
