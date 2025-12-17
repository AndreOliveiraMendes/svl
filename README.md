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

Clone the repository and create a symlink:

```sh
ln -s /path/to/svl/svl.sh $PREFIX/bin/svl
```

Make sure the script is executable:

```sh
chmod +x svl.sh
```

## Requirements

* Termux
* runit (`sv`)
* dpkg

## License

MIT

