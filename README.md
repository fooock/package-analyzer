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
```
Copyright 2017 newhouse (nhitbh at gmail dot com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
