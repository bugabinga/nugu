use palette.nu

export def theme [ mode: string ] {
	# nuon is pretty similar to lua tables!
	palette nugu $mode | to nuon | into string | str replace --all ':' ' =' | prepend 'return' | str join (char nl)
}
