# This file sets out some stuff you can tune.
# You can delete it, and sensible defaults will be loaded. But if you know the workload you intend to run on your machine, it's worth playing with these to optimise performance.

# The compressed swap is stored entirely in RAM, but requires CPU to compress and decompress it on the fly as it's needed. As you use more swap, the physical memory usage for the compressed swap will grow. But until that time, the physical RAM remains free for normal usage without performance impact. percentageOfRamToUse sets the maximum amount of physical RAM that can be used for storing the swap. Making this too small will give you very little swap to increase your viable memory. Setting this too large can leave your machine in a state where it is constantly paging in and our of swap to be able to get anything done, which severely hurts performance.
percentageOfRamToUse="80"

# device chooses which device you want to use. Most of the time, this will be zram0. But if you are already using zram0 for something else, this is the place to change it.
device="zram0"

# fullDevice is for future compatibility, and for compatibility for systems I haven't thought of yet. It's simply the path to the device that zram provides.
fullDevice="/dev/$device"

# coresToKeepFree defines how many cores are kept free for doing actual work (as opposed to handling compression for zram.) Keeping more cores free will make the actual work faster during swapping events, while keeping less free will help the swapping events pass quicker. In my experience so far, 1 seems to be a good number: actual work can get done if it has everything it needs, while zram can finish as quickly as possible. If your machine only has one core, you'll probably need to set this to 0. Otherwise probably 1.
coresToKeepFree=1

# Swappiness. There are lots of opinions about what this should be set to. I suggest googling it and working out what is right for you and your workload. Here's a promising article: https://www.howtogeek.com/449691/what-is-swapiness-on-linux-and-how-to-change-it/
swappiness=0

# compressionRatio. How many times bigger our compressed swap is going to be than the amount of RAM we are using to feed it. Eg If we set this to 3.2, it would mean that we are telling the ZRAM module that our data can easily compress to the degree that we could fit 3.2 times as much data into the same place. The ZRAM module will trust you, and horrible/hard to debug things will happen some time in the future if you are wrong. Setting this number lower is safer. Setting it higher gives you more useable swap. 2 seems to be fairly safe, in that I have not been able to crash it with any of my workloads yet. If you set this too high and things crash. Don't panic. All you need to do is set it to a lower value and reboot. Do understand that in this situation, and data that was being worked with when the ZRAM module ran out of memory, is likely corrupted. So anything that was being worked on should not be trusted.
compressionRatio=2
