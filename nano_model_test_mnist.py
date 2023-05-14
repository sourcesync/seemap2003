import os
import sys
import time
import platform

print("%s: Importing ml packages..." % platform.node())
print("")
from fastai.vision.all import *
import torch
from torchvision import datasets, models, transforms

TEST_MODE=False

if __name__ == '__main__':

    print("%s: Preparing images..." % platform.node())
    print("")
    block = DataBlock(
        blocks=(ImageBlock, CategoryBlock),
        get_items=get_image_files,
        splitter=RandomSplitter(valid_pct=0.2, seed=42),
        get_y=parent_label)

    loaders = block.dataloaders( "/home/mnist_png/training")

    print("%s: Loading model file" % platform.node(), sys.argv[1])
    print("")
    if os.path.exists(sys.argv[1]) or TEST_MODE:
        pm = torch.load( os.path.join("/home/",sys.argv[1]) )
    else:
        #useful for our automated tests
        pm = torch.load( "/home/test_fastai_mnist.pt")

    print("%s: Starting inference speed test..." % platform.node())
    print("")
    zt = st = ct = time.time()
    total_predictions = 0

    while ( st - zt < 30 ): # do total test for under a min

        # load a batch of images
        b = loaders.one_batch()

        # perform predictions on the batch
        o = pm(b[0])
        total_predictions += o.shape[0]

        # emit rate every few seconds
        ct = time.time()
        if ct-st>3:
            print("%s: Inference/Pediction rate=" % platform.node(), total_predictions/(ct-st) )

            # reset and do again...
            st = time.time()
            total_predictions = 0

    print("%s: Timing test done." % platform.node())


