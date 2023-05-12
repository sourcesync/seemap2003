import os
import sys
import time

print("Importing ml packages...")
from fastai.vision.all import *
import torch
from torchvision import datasets, models, transforms


if __name__ == '__main__':

    print("Preparing images...") 
    block = DataBlock(
        blocks=(ImageBlock, CategoryBlock),
        get_items=get_image_files,
        splitter=RandomSplitter(valid_pct=0.2, seed=42),
        get_y=parent_label)

    loaders = block.dataloaders( "/home/mnist_png/training")

    print("Loading model file", sys.argv[1])
    pm = torch.load( os.path.join("/home/",sys.argv[1]) )

    print("Starting inference speed test...")
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
            print("prediction rate=", total_predictions/(ct-st) )

            # reset and do again...
            st = time.time()
            total_predictions = 0

    print("Timing test done.")
