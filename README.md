# Traffic Light Classification

---
Original was posted at this location:

https://github.com/alex-lechner/Traffic-Light-Classification

https://github.com/swirlingsand/deeper-traffic-lights

This has been modified to work in June 2018 on Ubuntu 16.04

---
## Collecting Data

## Training on AWS
Please see AWS_Quickstart.md

## Analyze on Jupyter Notebook

I've modified the CarND Object Detection Lab to evaluate the trained models. I've also taken the rosbags and turned them into mp4 files

### Requirements

Install environment with [Anaconda](https://www.continuum.io/downloads):

```sh
conda env create -f environment.yml
```

After you initialize the environment, you will also need to update python path to point to the object_detection library
```sh
source activate tl-model-make
cd tensorflow/models/research
protoc object_detection/protos/*.proto --python_out=.
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
cd ../../..
```

Then you may start the juptyer Notebook
```sh
jupyter notebook
```
