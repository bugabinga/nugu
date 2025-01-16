set shell := [ "nu", "--commands" ]

neovim_config_dir :=  if os_family() == "windows" { "~/AppData/Local/nvim" } else { "~/.config/nvim" }
helix_config_dir :=  if os_family() == "windows" { "~/AppData/Roaming/helix" } else { "~/.config/helix" }

default:
	@just --list

lint:
	taplo lint
	open nugu.nu | nu-check --as-module --debug nugu.nu
	open site.nu | nu-check --as-module --debug site.nu
	open helix.nu | nu-check --as-module --debug helix.nu
	open wezterm.nu | nu-check --as-module --debug wezterm.nu

fmt: lint
	taplo fmt

output := 'output'

show THEME:
	use nugu.nu; nugu print-colors (nugu {{THEME}})

build: fmt
	rm --force --recursive {{output}}
	mkdir {{output}}
	use nugu.nu; nugu dark  | to toml | save --raw {{output}}/dark.toml
	use nugu.nu; nugu light | to toml | save --raw {{output}}/light.toml

html: build
	use site.nu; site html light | save --raw {{output}}/site-light.html
	use site.nu; site html dark  | save --raw {{output}}/site-dark.html

open: html
	firefox --new-tab {{output}}/site-dark.html
	firefox --new-tab {{output}}/site-light.html

helix: build
	rm --force --recursive {{output}}/helix
	mkdir {{output}}/helix
	use helix.nu; helix theme dark  | save --raw {{output}}/helix/nugu-dark.toml
	use helix.nu; helix theme light | save --raw {{output}}/helix/nugu-light.toml
	cp {{output}}/helix/nugu-dark.toml {{helix_config_dir}}/themes/nugu-dark.toml
	cp {{output}}/helix/nugu-light.toml {{helix_config_dir}}/helix/themes/nugu-light.toml
	try { pkill -USR1 hx }

wezterm: build
	rm --force --recursive {{output}}/wezterm
	mkdir {{output}}/wezterm
	use wezterm.nu; wezterm theme dark | save --raw {{output}}/wezterm/palette_dark.lua
	use wezterm.nu; wezterm theme light | save --raw {{output}}/wezterm/palette_light.lua
	cp {{output}}/wezterm/palette_dark.lua ~/.config/wezterm/bugabinga/nugu/palette_dark.lua
	cp {{output}}/wezterm/palette_light.lua ~/.config/wezterm/bugabinga/nugu/palette_light.lua

neovim: build
	rm --force --recursive {{output}}/neovim
	mkdir {{output}}/neovim
	use neovim.nu; neovim theme dark | save --raw {{output}}/neovim/palette_dark.lua
	use neovim.nu; neovim theme light | save --raw {{output}}/neovim/palette_light.lua
	cp {{output}}/neovim/palette_dark.lua {{neovim_config_dir}}/lua/bugabinga/nugu/palette_dark.lua
	cp {{output}}/neovim/palette_light.lua {{neovim_config_dir}}/lua/bugabinga/nugu/palette_light.lua
	try { pkill -USR1 nvim }

install: helix wezterm neovim
