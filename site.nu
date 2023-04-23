def brighten [] {
  pastel color | pastel lighten 0.33 | pastel desaturate 0.33 | pastel format hex
}

def to-divs [] {
  select 0 |
  transpose name value |
  each { | color |
  let bright = ($color.value | brighten | str trim)
  $"<div class='color_rect' style='background-color: ($color.value)'>
  <span class='color_name grow' onclick='copy\(\"($color.value)\"\)'>($color.name) ($color.value)</span>
  <span class='color_name grow' onclick='copy\(\"($bright)\"\)' style='color:white; background-color: ($bright)'>🔆 ($bright)</span>
  </div>"
  } |
  str join (char newline)
}

export def html [ theme: string ] {
	let palette = ( open $"output/($theme).toml" | get palette )
	let palette_colors = ( $palette | reject content ui )
	let content_colors = ( $palette | get content )
	let ui_colors = ( $palette | get ui )

	let global_color_divs = ( $palette_colors | to-divs )
	let content_color_divs = ( $content_colors | to-divs )
	let ui_color_divs = ( $ui_colors | to-divs )
  let backdrop = if $theme == "dark" { "black" } else { "white" }
  let normal = if $theme == "dark" { "white" } else { "black" }

  $"
  <!DOCTYPE html>
  <html>
  <script>
  function copy\(color\) {
    navigator.clipboard.writeText\(color\);
    alert\('Copied ' + color + ' into clipboard!'\);
  }
  </script>
  <style>
  :root {
    background-color: ($backdrop);
  }
  h1, h2 {
    font-family: serif;
    color: $normal;
  }
  h1::before {
    content: '# ';
  }
  h2::before {
    content: '## ';
  }
  .grid {
    display: grid;
    grid-template-columns: auto auto auto;
    grid-template-rows: auto auto auto; 
    column-gap: 16px;
    row-gap: 16px;
    padding: 16px;
  }
  .color_rect {
    width: 270px;
    height: 250px;
    border: ($normal) 5px solid;
    border-radius: 8px;
    display: inline-flex;
  }
  .color_name {
    font-family: monospace;
    font-weight: bold;
    font-size: smaller;
    color: white;
    opacity: 0.66;
    border-radius: 8px;
    background-color: $normal;
    padding: 8px;
    place-self: end;
  }
  .grow {
    transition: all .2s ease-in-out;
  }
  .grow:hover {
    cursor: pointer;
    border: $normal 2px solid;
    transform: scale\(1.666\);
    z-index: 999;
  }
  </style>
  <h1>nugu color palette</h1>

  <h2>global colors</h2>
  <div class='grid'>
  ($global_color_divs)
  </div>

  <h2>content colors</h2>
  <div class='grid'>
  ($content_color_divs)
  </div>

  <h2>ui colors</h2>
  <div class='grid'>
  ($ui_color_divs)
  </div>
  </html>
  "
}
