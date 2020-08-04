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
