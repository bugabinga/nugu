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

export def dark [] {
	let base = (open base.toml | get palette)

	let darkness = 0.190
	let lightness = 0.076
	let saturation = 0.087
	let mix = 0.33

	let error = (
							$base.error 
							| pastel mix --fraction $mix $base.accent 
							| pastel desaturate $saturation
							| pastel darken $darkness
							| pastel format hex
							| str trim
							)
	let warning = (
							$base.warning 
							| pastel mix --fraction $mix $base.accent 
							| pastel desaturate $saturation
							| pastel darken $darkness
							| pastel format hex
							| str trim
							)
	let info = (
							$base.info 
							| pastel mix --fraction $mix $base.accent 
							| pastel desaturate $saturation
							| pastel darken $darkness
							| pastel format hex
							| str trim
							)


	let content_normal = (
							$base.normal 
							| pastel darken $darkness
							| pastel format hex
							| str trim
							)
	let content_backdrop = (
							$base.backdrop 
							| pastel lighten $lightness
							| pastel format hex
							| str trim
							)
	let content_accent = (
							$base.accent 
							| pastel format hex
							| str trim
							)
	let content_minor = (
							$base.normal
							| pastel mix --fraction $mix $base.backdrop 
							| pastel darken $darkness 
							| pastel format hex
							| str trim
							)
	let content_focus = (
							$base.focus
							| pastel mix --fraction $mix $content_normal
							| pastel mix --fraction $mix $base.important
							| pastel lighten $lightness
							| pastel format hex
							| str trim
							)
	let content_unfocus = (
							$base.focus
							| pastel mix --fraction $mix $content_backdrop
							| pastel mix --fraction $mix $base.important
							| pastel desaturate $saturation 
							| pastel darken $darkness
							| pastel format hex
							| str trim
							)
	let content_important_local = (
							$base.important
							| pastel mix --fraction $mix $content_normal
							| pastel mix --fraction $mix $base.important
							| pastel mix --fraction $mix $base.accent
							| pastel desaturate $saturation 
							| pastel format hex
							| str trim
							)
	let content_important_global = (
							$base.important
							| pastel mix --fraction $mix $content_normal
							| pastel mix --fraction $mix $base.important
							| pastel mix --fraction $mix $base.accent
							| pastel lighten $lightness 
							| pastel desaturate $saturation 
							| pastel format hex
							| str trim
							)


	let ui_normal = (
							$content_normal 
							| pastel lighten $lightness 
							| pastel format hex
							| str trim
							)
	let ui_backdrop = (
							$content_backdrop 
							| pastel darken $darkness 
							| pastel format hex
							| str trim
							)
	let ui_accent = (
							$content_accent 
							| pastel darken $darkness 
							| pastel desaturate $saturation
							| pastel format hex
							| str trim
							)
	let ui_minor = (
							$content_normal 
							| pastel darken $darkness 
							| pastel desaturate $saturation
							| pastel format hex
							| str trim
							)
	let ui_focus = (
							$content_focus 
							| pastel darken $darkness 
							| pastel desaturate $saturation
							| pastel format hex
							| str trim
							)
	let ui_unfocus = (
							$content_unfocus 
							| pastel darken $darkness 
							| pastel desaturate $saturation
							| pastel format hex
							| str trim
							)
	let ui_important_local = (
							$content_important_local
							| pastel darken $darkness 
							| pastel desaturate $saturation
							| pastel format hex
							| str trim
							)
	let ui_important_global = (
							$content_important_global
							| pastel darken $darkness 
							| pastel desaturate $saturation 
							| pastel format hex
							| str trim
							)

	make-palette $base.debug $error $warning $info $content_normal $content_backdrop $content_accent $content_minor $content_focus $content_unfocus $content_important_local $content_important_global $ui_normal $ui_backdrop $ui_accent $ui_minor $ui_focus $ui_unfocus $ui_important_local $ui_important_global
}

export def light [] {
	let base = (open base.toml | get palette)

	let darkness = 0.219
	let lightness = 0.076
	let saturation = 0.06
	let mix = 0.33

	let error = (
							$base.error 
							| pastel mix --fraction $mix $base.accent 
							| pastel desaturate $saturation
							| pastel darken $darkness 
							| pastel format hex
							| str trim
							)
	let warning = (
							$base.warning 
							| pastel mix --fraction $mix $base.accent 
							| pastel desaturate $saturation
							| pastel darken $darkness
							| pastel format hex
							| str trim
							)
	let info = (
							$base.info 
							| pastel mix --fraction $mix $base.accent 
							| pastel desaturate $saturation
							| pastel darken $darkness 
							| pastel format hex
							| str trim
							)


	let content_normal = (
							$base.backdrop 
							| pastel lighten $lightness
							| pastel format hex
							| str trim
							)
	let content_backdrop = (
							$base.normal 
							| pastel darken $darkness
							| pastel format hex
							| str trim
							)
	let content_accent = (
							$base.accent 
							| pastel format hex
							| str trim
							)
	let content_minor = (
							$base.normal
							| pastel mix --fraction $mix $base.backdrop 
							| pastel darken $darkness 
							| pastel format hex
							| str trim
							)
	let content_focus = (
							$base.focus
							| pastel mix --fraction $mix $content_normal
							| pastel mix --fraction $mix $base.important
							| pastel desaturate $saturation 
							| pastel darken $darkness
							| pastel format hex
							| str trim
							)
	let content_unfocus = (
							$base.focus
							| pastel mix --fraction $mix $content_normal
							| pastel mix --fraction $mix $base.important
							| pastel desaturate $saturation 
							| pastel lighten $lightness 
							| pastel format hex
							| str trim
							)
	let content_important_local = (
							$base.important
							| pastel mix --fraction $mix $content_normal
							| pastel mix --fraction $mix $base.accent
							| pastel desaturate $saturation 
							| pastel darken $darkness 
							| pastel format hex
							| str trim
							)
	let content_important_global = (
							$base.important
							| pastel mix --fraction $mix $content_normal
							| pastel mix --fraction $mix $base.accent
							| pastel desaturate $saturation 
							| pastel format hex
							| str trim
							)


	let ui_normal = (
							$content_normal
							| pastel darken $darkness 
							| pastel format hex
							| str trim
							)
	let ui_backdrop = (
							$content_backdrop
							| pastel lighten $lightness 
							| pastel format hex
							| str trim
							)
	let ui_accent = (
							$content_accent 
							| pastel desaturate $saturation 
							| pastel format hex
							| str trim
							)
	let ui_minor = (
							$content_minor 
							| pastel lighten $lightness 
							| pastel format hex
							| str trim
							)
	let ui_focus = (
							$content_focus 
							| pastel desaturate $saturation
							| pastel format hex
							| str trim
							)
	let ui_unfocus = (
							$content_focus 
							| pastel desaturate $saturation
							| pastel format hex
							| str trim
							)
	let ui_important_local = (
							$content_important_local
							| pastel desaturate $saturation 
							| pastel format hex
							| str trim
							)
	let ui_important_global = (
							$content_important_global
							| pastel desaturate $saturation 
							| pastel format hex
							| str trim
							)

	make-palette $base.debug $error $warning $info $content_normal $content_backdrop $content_accent $content_minor $content_focus $content_unfocus $content_important_local $content_important_global $ui_normal $ui_backdrop $ui_accent $ui_minor $ui_focus $ui_unfocus $ui_important_local $ui_important_global
}
