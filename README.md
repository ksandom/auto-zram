# auto-zram

Automatically configure zram as swap on a machine, using sensible defaults.

Originally inspired by [this gist](https://gist.github.com/sultanqasim/79799883c6b81c710e36a38008dfa374) which configures zram on a Raspberry Pi with exact specifications.

## Install

Currently the install method is assumed to be systemd, however the script has been structures to slot right in to a traditional `init.d` style service management.

```bash
sudo make install
```

## Using it

### All the normal systemd stuff

```bash
sudo systemctl status auto-zram.service
```

```bash
sudo systemctl start auto-zram.service
```

```bash
sudo systemctl stop auto-zram.service
```

### More output

```bash
$ auto-zram status
Config
  % of memory to use  80
  device              zram0
  device config       /sys/devices/virtual/block/zram0
Derived config/knowledge
  Memory (MB)
    total               7977
    maxPhysicalUsage    6381
    virtualSize         12762
    uncompressed        1596
    ---
    totalPossible       14358

  CPU
    coresAvailable      2
    coresToUse          1

State
  General
    module              loaded
    device              mounted

  Mount
    NAME                   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    zram0                  252:0    0 12,5G  0 disk [SWAP]

  Swap
                  total        used        free      shared  buff/cache   available
    Swap:         12761           0       12761
```

Or via systemd
```bash
journalctl -u auto-zram.service
```

## Contributions

Pull requests welcome :)
