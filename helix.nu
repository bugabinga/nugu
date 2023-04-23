export def theme [ mode:string ] {
  let nugu = if $mode == "dark" { (dark_palette) } else { (light_palette) }
  let helix_palette = [
    [
      normal
      accent
      backdrop
      important_local
      important_global
      minor
      minor_backdrop
      ui_normal
      ui_selection
      ui_cursor
      ui_cursor_insert
      ui_cursor_selection
      ui_backdrop
      ui_important
      ui_minor
      error
      warning
      info
      debug
    ];
    [
       $nugu.palette.content.normal 
       $nugu.palette.content.accent 
       $nugu.palette.content.backdrop
       $nugu.palette.content.important_local
       $nugu.palette.content.important_global
       $nugu.palette.content.minor
       $nugu.palette.content.unfocus
       $nugu.palette.ui.normal
       $nugu.palette.ui.accent
       $nugu.palette.ui.focus
       $nugu.palette.ui.important_local
       $nugu.palette.ui.accent
       $nugu.palette.ui.backdrop
       $nugu.palette.ui.important_global
       $nugu.palette.ui.minor
       $nugu.palette.error
       $nugu.palette.warning
       $nugu.palette.info
       $nugu.palette.debug
      
    ]
  ]

  [ (stub) ($helix_palette | to toml | into string )] | str join (char newline)
}

def dark_palette [] { open output/dark.toml }
def light_palette [] { open output/light.toml }
def stub [] { open --raw helix_nugu_stub.toml | lines | drop 2 | str join (char newline) }
