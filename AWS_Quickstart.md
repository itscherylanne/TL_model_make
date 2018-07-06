# Quickstart Guide to Re-Training Models on AWS

This is a guide to getting AWS up and running so that we may re-train Tensorflow's models to work with the gathered traffic light data for Udacity's Capstone Integration Project.


This is based off of other Udacity student's TL Detection projects. You may find their projects at this location:
https://github.com/alex-lechner/Traffic-Light-Classification
https://github.com/swirlingsand/deeper-traffic-lights

-------------
### Getting your Term 3 AWS Credits from Udacity

As a reminder, you get another $100 credit for enrolling in term 3 in Udacity's SDC-ND. I assume you already have an AWS account, if not, go through the walkthrough in Term 1.

To get the credit, fill out the form located [here](https://www.awseducate.com/PromotionSignup?pcode=400HZJ).

If the link above does not work, you can find the link in your classroom resources folder.

### Setting up your AWS Instance

To set up an AWS spot instance do the following steps:
1. [Login to your Amazon AWS Account][aws login]
2. Navigate to ``EC2`` -> ``Instances`` -> ``Spot Requests`` -> ``Request Spot Instances``
3. Under ``AMI`` click on ``Search for AMI``, type ``udacity-carnd-advanced-deep-learning`` in the search field, choose ``Community AMIs`` from the drop-down and select the AMI (**This AMI is only available in US Regions so make sure you request a spot instance from there!**)Development/TL_model_make/data/bosch_train.record
4. Delete the default instance type, click on ``Select`` and select the ``g2.2xlarge`` instance
5. **IMPORTANT** Uncheck the ``Delete`` checkbox under ``EBS Volumes`` so your progress is not deleted when the instance get's terminated.

  **CAEd: LESSON LEARNED: I didn't do this and lost several whole day's worth of trained data.** If you know how to recover the data, after the instance is terminated (and deleted), please let me know so we can update this markdown file to include the steps for gathering that data.

6. Set ``Security Groups`` to ``default``
  **NOTE:** if you cannot connect to your instance on SSH, you may be able to add the security group settings from Term 1 (i.e. Launch Wizard or Jupyter). You can do this after your instance has launched. Then try connecting via SSH again.
7. Select your key pair under ``Key pair name`` (if you don't have one create a new key pair) **SAVE THIS PEM file and distribute it if you want to log into your instance from different computers**
8. At the very bottom set ``Request valid until`` to about **24 - 48 hours** (if you're running it while you go to work. I am setting mine to last a week because I am currently anticipating the birth of my child) and set ``Terminate instances at expiration`` as checked (You don't have to do this but keep in mind to receive a very large bill from AWS if you forget to terminate your spot instance because the default value for termination is set to 1 year.)
9. Click ``Launch``, wait until the instance is created and then connect to your instance via ssh

### Logging into your Instance
Follow AWS's instruction for logging into your instance.

**Note:** If you did not add your .pem file to your environment paths, make sure your terminal either references the fullpath to the .pem file or that you are connecting to your instance from the same directory as the .pem file.

**NOTE:** log in as `ubuntu` and not as `root`
```
cd wherever/your/pem/file_may_be
chmod 400 capstone.pem
ssh -i "capstone.pem" ubuntu@ec2-<SOME_IP_ADDRESS>.us-west-1.compute.amazonaws.com
```

### Setting up your environment

1. Clone this repository to your instance
```
git clone https://github.com/itscherylanne/TL_model_make
```
2. Go into repo directory
```
cd TL_model_make
```
3. Get updates, setup tensorflow to version 1.4 and check out the TF model creation repository (that works with TF v1.4)
```
chmod +x 01_tf_setup.sh
./01_tf_setup.sh
```
4. Download and unzip pre-trained models into the **model** folder
```
chmod +x 02_download_and_unzip_models.sh
./02_download_and_unzip_models.sh
```

5.  Download TF record files into the **data** folder on your LOCAL computer. I unfortunately could not figure out how to script downloading from my Google drive directly into my EC2 instance.

There are 4 different TF record files:
- [real_data.record] (https://drive.google.com/open?id=1ezhKl2B4T_TJv-eJYsU_ub_bmMKi8iwr)
- [sim_data.record] (https://drive.google.com/open?id=1I1OV2Mi1regq73U4wOXue4qEldgjZaob)
- [bosch_train.record] (https://drive.google.com/open?id=1iBmPV182itpleDSv8ZHviNwa4v_MoExR) <-- I am working on this one.
- [bosch_train_14labels.record] (https://drive.google.com/open?id=1e7mYNrVtYrwW3XjDjUMzIHBI69XcsJIH)


6. Upload TF record files from local to your EC2 instance. Unfortunately, I was not able to get a script to work for this step, so you may have to manually enter the commands in your local terminal. You will need to do this for each of the record files you wish to train with.

The <SOME_IP_ADDRESS> corresponds to the address from the section `Logging into your Instance`

General command:
```
scp -i <FULLPATH_TO_YOUR_PEM_FILE> \
  <LOCATION_OF_YOUR_RECORD_FILE> \
  ubuntu@ec2-<SOME_IP_ADDRESS>.us-west-1.compute.amazonaws.com:~/TL_model_make/data
```

Example for bosch_train.record:
```
scp -i ~/capstone.pem \
  ~/Development/TL_model_make/data/bosch_train.record  \
  ubuntu@ec2-XX-XX-XXX-XXX.us-west-1.compute.amazonaws.com:~/TL_model_make/data
```

### Setting up your config file.
You will need to download a local copy of the model's configuration files. I have included those files for your convenience in `config\original_configs`.

There are a few parameters you need to be aware of that require updating:
- `input_path:` This should be set to your .record file that you are using for training.
- `label_map_path:` This contains the indices for the labels corresponding to your .record file. Most files should utilize `labels\udacity_label_map.pbtext` the only exception is for `data\bosch_train_14labels.record` which should utilize `labels\bosch_14label_map.pbtxt`
- `num_steps:` Reduce this down to 20000
- `batch_size:` Reduce this to 3. You will get a resource error for any value larger than 3.
- `fine_tune_checkpoint:` Location where you wish for the .ckpt files to be saved. I decided just to keep it where the original model should be.

Upload the config file to your EC2 instance.

Example:
```
scp -i ~/capstone.pem \
        ~/Development/TL_model_make/config/ssd_inception_v2_bosch_train_udacity_label.config \
        ubuntu@ec2-XX-XX-XXX-XXX.us-west-1.compute.amazonaws.com:~/TL_model_make/config
```

### Training your models
I already have a copy of the `train.py` script from `tensorflow/models/research/object_detection`. All you need to do is run the command:

```
python train.py --logtostderr --train_dir=./models/train --pipeline_config_path=./config/your_tensorflow_model.config
```


### Exporting your model  / Freezing the Graph
When training is finished the trained model needs to be exported as a frozen inference graph. Udacity's Carla has TensorFlow Version 1.3 installed. However, the minimum version of TensorFlow needs to be Version 1.4 in order to freeze the graph but note that this does not raise any compatibility issues.

To freeze the graph:
```
python export_inference_graph.py --input_type image_tensor --pipeline_config_path ./config/ssd_inception_v2_bosch_train_udacity_label.config --trained_checkpoint_prefix ./models/train/model.ckpt-20000 --output_directory models
```
This will freeze and output the graph as ``frozen_inference_graph.pb``.


Download your frozen graph to your local computer:
```
scp -i ~/capstone.pem \
        ubuntu@ec2-XX-XX-XXX-XXX.us-west-1.compute.amazonaws.com:~/TL_model_make/models/train/* \
        ~/Development/TL_model_make/models/train/

scp -i ~/capstone.pem \
        ubuntu@ec2-XX-XX-XXX-XXX.us-west-1.compute.amazonaws.com:~/TL_model_make/models/frozen_inference_graph.pb \
        ~/Development/TL_model_make/models/train/

scp -i ~/capstone.pem \
        ubuntu@ec2-XX-XX-XXX-XXX.us-west-1.compute.amazonaws.com:~/TL_model_make/models/model.* \
        ~/Development/TL_model_make/models/train/

```   
---------------
### Random notes to self
```
cd tensorflow/models/research
protoc object_detection/protos/*.proto --python_out=.
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
cd ../../..

```

```
python train.py --logtostderr \
      --train_dir=./models/ssd_inception_v2_coco_11_06_2017/ \
      --pipline_config_path=./config/ssd_inception_v2_coco.config
```
