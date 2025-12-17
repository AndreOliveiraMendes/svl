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
````

List available services.

```sh
svl status
```

Show status of all services.

```sh
svl status <service> [service...]
```

Show status of one or more services.

```sh
svl who <service> [service...]
```

Show which package provides a service.

```sh
svl help
```

Show help message.

## Installation

Clone the repository and create a symlink to `svl.sh`:

```sh
git clone https://github.com/AndreOliveiraMendes/svl.git
cd svl
ln -s "$(pwd)/svl.sh" "$PREFIX/bin/svl"
````

Make sure the script is executable and $PREFIX/bin is in your PATH (it is by default in Termux).

```sh
chmod +x svl.sh
```

##Setup Autocompletion

After cloning this repository and entering the project directory, create a symbolic link to the Bash completion script:

```bash
ln -s "$(pwd)/completions/svl.bash" "$PREFIX/etc/bash_completion.d/svl"
```

Then reload Bash (or open a new terminal) for the changes to take effect.

## Requirements

* Termux
* runit (`sv`)
* dpkg
* bash-completion (if you want auto completion)

## License

MIT

