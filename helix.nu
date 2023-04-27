use palette.nu

export def theme [ mode:string ] {
  let nugu = (palette nugu $mode)
  let helix_palette = {
    normal: $nugu.palette.content.normal 
    backdrop: $nugu.palette.content.backdrop
    accent: $nugu.palette.content.accent 
    important_local: $nugu.palette.content.important_local
    important_global: $nugu.palette.content.important_global
    minor: $nugu.palette.content.minor
    focus: $nugu.palette.content.focus
    unfocus: $nugu.palette.content.unfocus

    ui_normal: $nugu.palette.ui.normal
    ui_backdrop: $nugu.palette.ui.backdrop
    ui_accent: $nugu.palette.ui.accent
    ui_important_global: $nugu.palette.ui.important_global
    ui_important_local: $nugu.palette.ui.important_local
    ui_minor: $nugu.palette.ui.minor
    ui_focus: $nugu.palette.ui.focus
    ui_unfocus: $nugu.palette.ui.unfocus

    error: $nugu.palette.error
    warning: $nugu.palette.warning
    info: $nugu.palette.info
    debug: $nugu.palette.debug
  }

  [ (stub) ($helix_palette | to toml | into string )] | str join (char newline)
}

def stub [] { open --raw helix_nugu_stub.toml | lines | drop 2 | str join (char newline) }
