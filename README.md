# auto-zram

Automatically configure zram as swap on a machine, using sensible defaults, with the ability to tweak it to your needs.

Originally inspired by [this gist](https://gist.github.com/sultanqasim/79799883c6b81c710e36a38008dfa374) which configures zram on a Raspberry Pi with exact specifications.

## Install

Currently the install method is assumed to be systemd, however the script has been structured to be easy to slot right in to a traditional `init.d` style service management.

```bash
sudo make install
```

## Using it

### All the normal systemd stuff

What state is is in right now?
```bash
sudo systemctl status auto-zram.service
```

Start it. (Configure zram as swap.)
```bash
sudo systemctl start auto-zram.service
```

Stop it. (Revert to what ever settings you would have if auto-zram was not in use.)
```bash
sudo systemctl stop auto-zram.service
```

Scroll through logs of what state it was in at various points in time. You'll probably want to press END on your keyboard to see the latest run.
```bash
journalctl -u auto-zram.service
```

### Figuring out what state stuff is in, or would be

What state does the current config produce?

```bash
$ auto-zram status
Config
  % of memory to use    80
  device                zram0
  device config         /sys/devices/virtual/block/zram0
  used config file      true
  config file           /etc/auto-zram.sh
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
    zram0                  252:0    0 12,6G  0 disk [SWAP]

  Swap
                  total        used        free      shared  buff/cache   available
    Swap:         12921           0       12921
```

NOTE that this is not necessarily what is in memory at this moment. For that use the `journalctl -u auto-zram.service` command above.


Or via systemd
```bash
journalctl -u auto-zram.service
```

See what the state of the machine would look like if you specified 40 as your `percentageOfRamToUse`.
```bash
auto-zram prototype 40
```

## Special note

You should only start or stop `auto-zram` when you have enough physical RAM to spare to cover everything that is currently in swap. If you don't, you'll probably have one of the "Remember that time when..." stories to tell.

## Contributions

Pull requests welcome :)
