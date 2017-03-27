# Package analyzer
This is a simple bash script to download the sources from the main repositories
of a distribution based in debian

## Getting started
First, clone this repo:
```bash
git clone https://github.com/fooock/package-analyzer.git
cd package-analyzer
```

## Usage
This script has two flags.
* **-n**: Number of packages to analyze
* **-s**: Preferred size of the packages to analyze in bytes

Imagine that you want to download only 10 packages with less than 10Mb each:

```bash
$ sudo ./fooocker.sh -n 10 -s 10000000
```

The output of the script is relative to the current directory. You can find it in ```$pwd/fooocker```

## Contributing
This work is under development, if you want to contribute fork it and send me a PR ;-)

## License
See LICENSE file in this repo
