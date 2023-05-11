import os
import sys

from fastai.vision.all import *
import torch
from torchvision import datasets, models, transforms


if __name__ == '__main__':

    block = DataBlock(
        blocks=(ImageBlock, CategoryBlock),
        get_items=get_image_files,
        splitter=RandomSplitter(valid_pct=0.2, seed=42),
        get_y=parent_label)

    loaders = block.dataloaders( "../data_nano/mnist_png/training")

    model = torch.load("../data_nano/fastai_mnist.pt") #seemap2023_ft.pt")
    print(type(model))

    for obj in model.state_dict():
        print(obj)

    b = loaders.one_batch()
    print(len(b))
    print( type(b[0]), b[0].shape)
    print( type(b[1]), b[1].shape)
    print( b[1][0] )
    pm = model
    o = pm(b[0])
    print( type(o), o.shape)
    print(o[0])
