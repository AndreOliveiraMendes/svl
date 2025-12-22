# svl

`svl` is a small Bash wrapper around `sv` (runit) for Termux.

It provides a simpler, more discoverable interface to list services,
check their status, and identify which package provides each service.

## Features

- List available runit services
- Show status for all or selected services
- Identify which package owns a service (`dpkg -S`)
- Designed specifically for Termux + runit
- Minimal, dependency-free Bash script

## Usage

```sh
svl
```

List available services, you can also use `svl list` which does the same thing

```sh
svl status [services ...]
```

Show the status of all services. If no service is specified, it shows the status of all available services.

```sh
svl who [service...]
```

Show which package provides a service, If no service is specified, it shows the provider for all available services.

```sh
svl help
```

Show help message.

you can also use `man svl` to read the manual pages for svl

## Requirements

* Termux
* runit (`sv`)
* dpkg
* bash-completion (if you want auto completion to work)

## Internal Details

In Termux, runit services are stored in:

* `$PREFIX/var/service`

Each directory represents a runit service.

## Instaling

You can install `svl` in two ways:

Clone the repository:

```sh
git clone https://github.com/AndreOliveiraMendes/svl.git
cd svl
```

from there, you have 2 option

### Local installation (symlink)

from inside the svl folder, run the following comand to create a symlink to svl.sh

```sh
ln -s "$(pwd)/svl.sh" "$PREFIX/bin/svl"
```

Make sure the script is executable and $PREFIX/bin is in your PATH (it is by default in Termux).

```sh
chmod +x svl.sh
```

to setup the auto complet, proced in similiar way as before, creating a symlink to completion script

```bash
ln -s "$(pwd)/completions/svl.bash" "$PREFIX/etc/bash_completion.d/svl"
```

Then reload Bash (or open a new terminal) for the changes to take effect.

### Local installation (package)

from inside the svl folder, run the following script

```sh
./script/pkg-build.sh
```

this should generate a pkg folder, then, run:

```sh
dpkg -i pkg/svl.deb
```

now you can use svl, but you need to reload bash (or open a new terminal) to use auto complet

## Examples

### Listing services

```sh
$ svl
mysqld ssh-agent sshd
```

### Checking status

```sh
$ svl status sshd
service path: /data/data/com.termux/files/usr/var/service/sshd
run: /data/data/com.termux/files/usr/var/service/sshd: (pid 15048) 75185s; run: log: (pid 15047) 75185s
```

Other available commands:

* `svl who [service...]` — show which package provides a service (also indicates locally created services)
* `svl help`, `svl --help`, or `svl -h` — show the help message

There may be other commands not listed here.
If in doubt, use `svl help` or read the manual page:

* `man svl` — open the manual page for svl

## License

MIT

