def print-block [ color: string ] {

	let color_escape = {
		fg: $color
		bg: $color
	}

	print --no-newline $"(ansi --escape $color_escape)██(ansi reset)"
}

export def print-colors [theme: record] {
	let mat = [
		[
			$theme.palette.debug
			$theme.palette.error
			$theme.palette.warning
			$theme.palette.info
			null
			null
			null
			null
		]
		[
			$theme.palette.content.normal
			$theme.palette.content.backdrop
			$theme.palette.content.accent
			$theme.palette.content.minor
			$theme.palette.content.focus
			$theme.palette.content.unfocus
			$theme.palette.content.important_local
			$theme.palette.content.important_global
		]
		[
			$theme.palette.ui.normal
			$theme.palette.ui.backdrop
			$theme.palette.ui.accent
			$theme.palette.ui.minor
			$theme.palette.ui.focus
			$theme.palette.ui.unfocus
			$theme.palette.ui.important_local
			$theme.palette.ui.important_global
		]
	]
	# FIXME: shirley, there is some clever way to create the matrix from the tree?

	let width = $mat | get 0 | length
	let height = $mat | length
	# FIXME: the math below is beautifully wrong and only happens to work
	# when pad is == 1, don't care right now..
	let pad = 1
	let size = (term size | get columns) // ($width + $width + $pad + $pad)
	let padded_size = $size + $pad

	let scaled_width = ($width * $padded_size) - $pad
	let scaled_height = ($height * $padded_size) - $pad

	let bg = "#000000"

	for y in 0..$scaled_height {
		for x in 0..$scaled_width {
			let pad_x = $x mod $padded_size
			let pad_y = $y mod $padded_size
			if ($pad_x == $padded_size - 1 or $pad_y == $padded_size - 1 ) {
				print-block $bg
			} else {
				let color_x = ($x // $padded_size) mod $width
				let color_y = ($y // $padded_size) mod $height
				let color = $mat | get $color_y | get $color_x
				if ($color | is-not-empty) {
					print-block $color
				} else {
					print-block $bg
				}
			}
		}
		# it is amazingly difficult to print only one newline
		# print --no-newline (char nl)
		print ""
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
	def normal_flux [ --c: float=0.169 --d:float=0.169 ] { if $light { flux $c $d --light } else { flux $c $d  } }
	def inverted_flux [ --c: float=0.069 --d:float=0.069 ] { if $light { flux $c $d } else { flux $c $d --light } }

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
		| normal_flux --c 0
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
		| normal_flux --c 0.042 --d 0.42
	)
	let content_unfocus = (
		$base.focus
		| mix $content_backdrop
		| mix $base.important
		| normal_flux --c 0.069 --d 0.69
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
		| normal_flux --c 0
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
		| normal_flux --c 0 --d 0.42
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
		| normal_flux
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
