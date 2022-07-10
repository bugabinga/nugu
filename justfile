set shell := [ "nu", "--commands" ]
default:
    @just --list
lint:
    taplo lint
    nu-check --as-module --debug nugu.nu
    nu-check --as-module --debug site.nu
fmt:
    taplo fmt
output := 'output'
build:
		rm --force --recursive {{output}}
		mkdir {{output}}
		use nugu.nu; nugu dark  | to toml | save --raw {{output}}/dark.toml
		use nugu.nu; nugu light | to toml | save --raw {{output}}/light.toml
		use site.nu; site html  | save --raw {{output}}/site.html
