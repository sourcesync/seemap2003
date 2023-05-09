import os
import sys
import torch
from torchvision import datasets, models, transforms


data_transforms = {
    'val': transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ]),
}


data_dir = '../data_nano/hymenoptera_data_val_small'

image_datasets = {x: datasets.ImageFolder(os.path.join(data_dir, x),
                                          data_transforms[x])
                  for x in ['val']}

dataloaders = {x: torch.utils.data.DataLoader(image_datasets[x], batch_size=4,
                                             shuffle=True, num_workers=0)
              for x in ['val']}

dataset_sizes = {x: len(image_datasets[x]) for x in ['val']}
class_names = image_datasets['val'].classes

if __name__ == '__main__':

    model = torch.load("../data_nano/seemap2023_ft.pt")
    #sd = torch.load("data/pruned_weights.pth")
    ##print(type(sd))
    #model = torch.nn.Module.load_state_dict(sd)
    print(type(model))

    was_training = model.training
    model.eval()
    images_so_far = 0

    with torch.no_grad():

        for i, (inputs, labels) in enumerate(dataloaders['val']):

            outputs = model(inputs)
            _, preds = torch.max(outputs, 1)

            for j in range(inputs.size()[0]):
                images_so_far += 1
                print( i,j, "pred=",class_names[preds[j]], "label=", class_names[labels[j]])


