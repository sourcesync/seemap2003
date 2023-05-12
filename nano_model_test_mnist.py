import os
import sys
import time

print("Import ml packages...")
from fastai.vision.all import *
import torch
from torchvision import datasets, models, transforms


if __name__ == '__main__':

    print("preparing images...") 
    block = DataBlock(
        blocks=(ImageBlock, CategoryBlock),
        get_items=get_image_files,
        splitter=RandomSplitter(valid_pct=0.2, seed=42),
        get_y=parent_label)

    loaders = block.dataloaders( "/home/mnist_png/training")

    print("loading model...")
    pm = torch.load("/home/fastai_mnist.pt") 

    print("starting inference...")
    st = time.time()
    total_predictions = 0

    while True:

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
