use palette.nu

export def theme [ mode:string ] {
  let nugu = (palette nugu $mode)
  let helix_palette = {
    normal: $nugu.palette.content.normal 
    accent: $nugu.palette.content.accent 
    backdrop: $nugu.palette.content.backdrop
    important_local: $nugu.palette.content.important_local
    important_global: $nugu.palette.content.important_global
    minor: $nugu.palette.content.minor
    minor_backdrop: $nugu.palette.content.unfocus
    ui_normal: $nugu.palette.ui.normal
    ui_selection: $nugu.palette.ui.accent
    ui_cursor: $nugu.palette.ui.focus
    ui_cursor_insert: $nugu.palette.ui.important_local
    ui_cursor_selection: $nugu.palette.ui.accent
    ui_backdrop: $nugu.palette.ui.backdrop
    ui_important: $nugu.palette.ui.important_global
    ui_minor: $nugu.palette.ui.minor
    error: $nugu.palette.error
    warning: $nugu.palette.warning
    info: $nugu.palette.info
    debug: $nugu.palette.debug
  }

  [ (stub) ($helix_palette | to toml | into string )] | str join (char newline)
}

def stub [] { open --raw helix_nugu_stub.toml | lines | drop 2 | str join (char newline) }
