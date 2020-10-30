# Compression ratios

## Why it's important to get this right

Normally when we compress a file of a certain size, eg 1MB, on the command line, we get to the results straight away and see a new file with something like 0.7MB, 0.5MB, 0.3MB. We might even see it get larger, eg 1.1MB, if the data is hard to compress.

That's fine. We take some input data, produce some output data of varying size, and all is well.

When it comes to swap on Linux, we currently mount a disk or file with a specific size as swap, to produce swap with a specific size. Note that the file could be lazy-allocated, which will give the illusion of it growing with usage. But that's a differnt topic. The point is that there are assumptions in multiple places that the storage is of a specific, unchanging size.

ZRAM replaces the storage component. It creates a virtual disk of specific size, entirely backed by RAM. We then mount that disk as SWAP, and we have our mechanism for compressing the parts of RAM that are less frequently used when there is memory pressure.

The nature of data compression is that we don't know small the compressed state will be without knowing the input data, the algorythm, and realistically, giving it a go. But we have to specify how big the swap space will be. Therefore we have to make assumptions about how well the data will compress.

If we assume that it will compress really well, we'll have much more swap available to use. But if the algorythm fails to get everything into the space available, assumptions break in bad ways and data corruption is highly likely. Converserly, if we assume that it won't compress well, but it actually does, we have wasted potential.

The trick is to know how well the data in your use-cases compresses.

## What auto-zram-monitor does

It

* Runs in the background, and every ____ seconds (default: 60) it will dump out statistics about the compression of your swap.
* Keeps a historical list of analysis about how your ZRAM based swap is compressing so that you can fine tune it.
    * This is output in JSON format, so you could feed this to your favourite monitoring tool.
    * You can see this with `journalctl -f -u auto-zram-monitorLoop.service`.
* Creates/updates stats in `/etc/auto-zram/stats` that you can
    * use to advise you on what a safe value is for `compressionRatio` in `/etc/auto-zram/config`.
    * include in your `/etc/auto-zram/config`, so that every time auto-zram starts, it will use the best compression ratio, based on your previous workloads.

## Working with it

### Install

```bash
sudo make install-monitor
```

### Uninstall

```bash
sudo make uninstall-monitor
```

### Viewing the results

```bash
journalctl -u auto-zram-monitorLoop.service
```

### Watching the results

```bash
journalctl -f -u auto-zram-monitorLoop.service
```

### Interpreting the results

* Keep in mind that when there is little data in swap, the statistics are little better than a guess. You need to fill it with data to get a more accurate reading.
* Just because you get one result on one use-case, does not mean you'll get the same result with the next use-case. It's worth getting data for all of your use-cases before adjusting the compression ratio.

### Using the results

#### Manual

Once you have values that you feel are safe for your use-case, you can adjust them in /etc/auto-zram/config

```bash
compressionRatio=2
```

Make sure to read the comment above the setting before saving.

#### Automatic

**If your data isn't particularly important to you, and you don't mind some crashes** from overly optimistic settings, you could try this in /etc/auto-zram/config, although it should be pretty stable after you've given it plenty of time (at least multiple days) to sample your different work loads:

```bash
compressionRatio="$(safeReadStat "saferRatio-min" "2")"
```

This essentially takes the previous detected minimum compression ratio, subtracts a little from it, and uses that as the assumption. If you haven't trained it on enough of your use-cases, this **will** tank your system when it gets under enough memory pressure. I therefore recommend a long run-in period with `auto-zram-monitorLoop.service` while you try your different use-cases.

NOTE that what ever you set it to, will not influence the statistics. So you can set it to something safe while gathering statistics.

IMPORTANT The `-max` values are there purely for interest. You should only ever use the `-min` values.

#### When will these new settings become active

After restarting the auto-zram service either via a reboot, or like this

```bash
sudo systemctl restart auto-zram.service
```

#### Continuing your statistics after a re-install

If you had stable settings before the re-install, you can simply copy your backup of `/etc/auto-zram/stats` back in place. It won't be less stable than before. 

You will, however, miss-out on any new optimisations that might be available in newer versions of packages. You could get around this by making the min values a bit more generous. If you go down this path, I recommend not including the values in your config until `auto-zram-monitorLoop.service` has had a good chance to see how the new versions of your software perform.

#### Manipulating values in /etc/auto-zram/stats

The purist in me is like "AHHHHH why are you telling people they can do this?!" But there is some value in understanding this. Keep in mind that doing this will invalidate assumptions that may be made about the statistics, so it should be made clear that you have modified them if you are seeking help on forums.

##### A worked example

Let's see what this looks like on a new set up

```
$ cat saferRatio-min 
61.297
```

Ouch! That is not realistic at all. Ideally, we'd let `auto-zram-monitorLoop.service` settle in for quite a while. But if we're in a hurry, we can set this to a more realistic value.

```
# echo 4 > saferRatio-min
# cat saferRatio-min
4
```

This is still high, but at least this is more realistic. But seriously, if you need your machine to be stable, run `auto-zram-monitorLoop.service` for a few days to get the optimum value that is realistic for your workloads.

