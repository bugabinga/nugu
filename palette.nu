export def nugu [ mode:string ] {
	if $mode == "dark" { (dark_palette) } else { (light_palette) }
}
def dark_palette [] { open output/dark.toml }
def light_palette [] { open output/light.toml }
