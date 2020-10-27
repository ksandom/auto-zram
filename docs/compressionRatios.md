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

* Keeps a historical list of analysis about how your ZRAM based swap is compressing so that you can fine tune it.
* More coming here.

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
* Just because you get one result on one use-case, does not mean you'll get the same result with the next use-case. It's worth getting data for all of your usecases before adjusting the compression ratio.

### Using the results

Once you have values that you feel are safe for your use-case, you can adjust them in /etc/auto-zram/config

```bash
compressionRatio=2
```

Make sure to read the comment above the setting before saving.
