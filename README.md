# Node Modules In Memory

Put your `node_modules` into your memory for Linux (maybe MacOS) user has enough memory.

## Install

``` bash
git clone https://github.com/hangxingliu/node-modules-in-memory
# for example: your current directory is /path/to/
# then append a command into your "~/.bashrc" or "~/.bash_profile" (or equivalent)
echo 'source /path/to/node-modules-in-memory/init.sh;' >> ~/.bashrc;
```

## Usage

``` bash
nmim start # start nmim from node_modules.tar
npim start --memory 500M

nmim save
nmim stop
nmim stop-all
```

## Author

[LiuYue @hangxingliu](https://github.com/hangxingliu)

## License

[GPL-3.0](LICENSE)
