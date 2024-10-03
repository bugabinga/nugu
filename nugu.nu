export def print-colors [theme: record] {
	echo "PALETTE"
		$theme.palette | reject content ui | select 0 | transpose name value | each { |color|
			echo $"NAME: ($color.name)"
				pastel color $color.value
		}
	echo "CONTENT"
		$theme.palette.content | select 0 | transpose name value | each { |color|
			echo $"NAME: ($color.name)"
				pastel color $color.value
		}
	echo "UI"
		$theme.palette.ui | select 0 | transpose name value | each { |color|
			echo $"NAME: ($color.name)"
				pastel color $color.value
		}
}

def make-palette [
	debug: string,
	error: string,
	warning: string,
	info: string,
	content_normal: string,
	content_backdrop: string,
	content_accent: string,
	content_minor: string,
	content_focus: string,
	content_unfocus: string,
	content_important_local: string,
	content_important_global: string,
	ui_normal: string,
	ui_backdrop: string,
	ui_accent: string,
	ui_minor: string,
	ui_focus: string,
	ui_unfocus: string,
	ui_important_local: string,
	ui_important_global: string
] {
		{
			palette: {
				debug: $debug
				error: $error
				warning: $warning
				info: $info
				content: {
					normal: $content_normal
					backdrop: $content_backdrop
					accent: $content_accent
					minor: $content_minor
					focus: $content_focus
					unfocus: $content_unfocus
					important_local: $content_important_local
					important_global: $content_important_global
				}
				ui: {
					normal: $ui_normal
					backdrop: $ui_backdrop
					accent: $ui_accent
					minor: $ui_minor
					focus: $ui_focus
					unfocus: $ui_unfocus
					important_local: $ui_important_local
					important_global: $ui_important_global
				}
			}
		}
}

# modifies a color by some cool operation -> flux.
# default flux is to darken.
def flux [
	compensator: float # power of the flux light
	deescalator: float # weaken the flux charisma
	--light # use the light variant of flux color modification
] {
	pastel desaturate $deescalator |
	pastel ( if $light { "lighten" } else { "darken" } ) $compensator |
	pastel format hex |
	ansi strip
}

def mix [
	color: string # color to mix into
] {
	pastel mix --colorspace OkLab --fraction 0.42 $color
}

def new [
	--light # make the light variant
] {
	let base = (open base.toml | get palette)
	def normal_flux [ c: float=0.0190 d:float=0.0087 ] { if $light { flux $c $d --light } else { flux $c $d  } }
	def inverted_flux [ c: float=0.0076 d:float=0.0006 ] { if $light { flux $c $d } else { flux $c $d --light } }

	let normal = if $light { $base.backdrop } else { $base.normal }
	let backdrop = if $light { $base.normal } else { $base.backdrop }

	let error = (
		$base.error
		| mix $base.accent
		| normal_flux
	)
	let warning = (
		$base.warning
		| mix $base.accent
		| normal_flux
	)
	let info = (
		$base.info
		| mix $base.accent
		| normal_flux
	)
	let content_normal = (
		$normal
		| normal_flux
	)
	let content_backdrop = (
		$backdrop
		| inverted_flux
	)
	let content_accent = (
		$base.accent
		| normal_flux 0.069 0.001
	)
	let content_minor = (
		$normal
		| mix $backdrop
		| normal_flux
	)
	let content_focus = (
		$base.focus
		| mix $content_normal
		| mix $base.important
		| normal_flux
	)
	let content_unfocus = (
		$base.focus
		| mix $content_backdrop
		| mix $base.important
		| normal_flux
	)
	let content_important_local = (
		$base.important
		| mix $content_normal
		| mix $base.important
		| mix $base.accent
		| normal_flux
	)
	let content_important_global = (
		$base.important
		| mix $content_normal
		| mix $base.important
		| mix $base.accent
		| normal_flux
	)
	let ui_normal = (
		$content_normal
		| inverted_flux
	)
	let ui_backdrop = (
		$content_backdrop
		| normal_flux
	)
	let ui_accent = (
		$content_accent
		| normal_flux 0.069 0.001
	)
	let ui_minor = (
		$content_minor
		| normal_flux
	)
	let ui_focus = (
		$content_focus
		| normal_flux
	)
	let ui_unfocus = (
		$content_unfocus
		| normal_flux 0.0 0.42
	)
	let ui_important_local = (
		$content_important_local
		| normal_flux
	)
	let ui_important_global = (
		$content_important_global
		| normal_flux
	)

	(make-palette $base.debug $error $warning $info
		$content_normal $content_backdrop
		$content_accent
		$content_minor
		$content_focus $content_unfocus
		$content_important_local $content_important_global
		$ui_normal $ui_backdrop
		$ui_accent
		$ui_minor
		$ui_focus $ui_unfocus
		$ui_important_local $ui_important_global)
}

export def dark [] { new }
export def light [] { new --light }
