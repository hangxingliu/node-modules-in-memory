# Node Modules In Memory

Put your `node_modules` into your memory for Linux user (MacOS support is coming soon) has enough memory.

## Work Flow

- Mount `node_modules` in memory
	- load persistent modules file `node_modules.tar` if it is existed.
- Then just programming as usual
- Save to `node_modules.tar` if you install/remove a module
- Unmount if you finish your work (or just keep it in the memory)

**Tip**: add `node_modules.tar` into your `.gitignore` and other ignore files.

## Install

``` bash
git clone https://github.com/hangxingliu/node-modules-in-memory
# for example: your current directory is /path/to/
# then append a command into your "~/.bashrc" or "~/.bash_profile" (or equivalent)
echo 'source /path/to/node-modules-in-memory/init.sh;' >> ~/.bashrc;
```

## Usage

``` bash
# usage help:
nmim help

# mount node_modules in memory
#   and load from `node_modules.tar` if it is existed
nmim start # default max memory is 50M
nmim start --memory 500M

# save node_modules to disk with name `node_modules.tar`
nmim save

# unmount node_modules from memory
nmim stop
nmim stop --save # --save: also save to `node_modules.tar`

# npm shortcut (mount if it isn't mounted)
nmim npm run dev
nmim npm install hangxingliu

# global actions
nmim status-all # list all mounted node_modules
nmim stop-all # stop all mounted node_modules
```

## TODO

- [ ] Support MacOS
	- Reference (tmpfs for OS X): <https://gist.github.com/Roman2K/3238fb441e298369198e>
	- Test `mount`, `mountpoint` and more ...
- [ ] add `check.sh` for checking dependencies
- [ ] auto growing size (it may be difficult)


## Author

[LiuYue @hangxingliu](https://github.com/hangxingliu)

## License

[GPL-3.0](LICENSE)
