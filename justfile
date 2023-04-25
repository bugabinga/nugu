set shell := [ "nu", "--commands" ]

default:
	@just --list

lint:
	taplo lint
	open nugu.nu | nu-check --as-module --debug nugu.nu
	open site.nu | nu-check --as-module --debug site.nu
	open helix.nu | nu-check --as-module --debug helix.nu

fmt: lint
	taplo fmt

output := 'output'

build: fmt
	rm --force --recursive {{output}}
	mkdir {{output}}
	use nugu.nu; nugu dark  | to toml | save --raw {{output}}/dark.toml
	use nugu.nu; nugu light | to toml | save --raw {{output}}/light.toml

html: build
	use site.nu; site html light | save --raw {{output}}/site-light.html
	use site.nu; site html dark  | save --raw {{output}}/site-dark.html

open: html
	firefox --new-window {{output}}/site-dark.html
	firefox --new-window {{output}}/site-light.html

helix: build
	rm --force --recursive {{output}}/helix
	mkdir {{output}}/helix
	use helix.nu; helix theme dark  | save --raw {{output}}/helix/nugu-dark.toml
	use helix.nu; helix theme light | save --raw {{output}}/helix/nugu-light.toml
	cp {{output}}/helix/nugu-dark.toml ~/.config/helix/themes/nugu-dark.toml
	cp {{output}}/helix/nugu-light.toml ~/.config/helix/themes/nugu-light.toml

wezterm: build
	rm --force --recursive {{output}}/wezterm
	mkdir {{output}}/wezterm
	use wezterm.nu; wezterm theme | save --raw {{output}}/wezterm/nugu.lua
	cp {{output}}/wezterm/nugu.lua ~/.config/wezterm/bugabinga/nugu.lua

install: helix wezterm
