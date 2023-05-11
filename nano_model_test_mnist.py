import os
import sys
import time

from fastai.vision.all import *
import torch
from torchvision import datasets, models, transforms


if __name__ == '__main__':

    print("preparing image loader...") 
    block = DataBlock(
        blocks=(ImageBlock, CategoryBlock),
        get_items=get_image_files,
        splitter=RandomSplitter(valid_pct=0.2, seed=42),
        get_y=parent_label)

    #loaders = block.dataloaders( "../data_nano/mnist_png/training")
    loaders = block.dataloaders( "/Users/gwilliams/.fastai/data/mnist_png/training")

    print("loading model...")
    pm = torch.load("./data/fastai_mnist.pt") 
    #print(type(pm))
    ##for obj in model.state_dict():
    #    print(obj)

    print("starting inference...")
    st = time.time()
    total_predictions = 0

    while True:
        b = loaders.one_batch()
        o = pm(b[0])
        total_predictions += o.shape[0]
        #print(o.shape)

        ct = time.time()
        if ct-st>3:
            print("prediction rate=", total_predictions/(ct-st) )
            st = time.time()
            total_predictions = 0
