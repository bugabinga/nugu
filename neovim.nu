use palette.nu

export def theme [ mode:string ] {
  let nugu = ( palette nugu $mode )
	$"return {
	debug = '($nugu.palette.debug)',
	error = '($nugu.palette.error)',
	info = '($nugu.palette.info)',
	warning = '($nugu.palette.warning)',

	content_normal = '($nugu.palette.content.normal)',
	content_backdrop = '($nugu.palette.content.backdrop)',
	content_accent = '($nugu.palette.content.accent)',
	content_minor = '($nugu.palette.content.minor)',
	content_focus = '($nugu.palette.content.focus)',
	content_unfocus = '($nugu.palette.content.unfocus)',
	content_important_global = '($nugu.palette.content.important_global)',
	content_important_local = '($nugu.palette.content.important_local)',

	ui_normal = '($nugu.palette.ui.normal)',
	ui_backdrop = '($nugu.palette.ui.backdrop)',
	ui_accent = '($nugu.palette.ui.accent)',
	ui_minor = '($nugu.palette.ui.minor)',
	ui_focus = '($nugu.palette.ui.focus)',
	ui_unfocus = '($nugu.palette.ui.unfocus)',
	ui_important_global = '($nugu.palette.ui.important_global)',
	ui_important_local = '($nugu.palette.ui.important_local)',
}"
}

