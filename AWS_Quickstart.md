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
3. Under ``AMI`` click on ``Search for AMI``, type ``udacity-carnd-advanced-deep-learning`` in the search field, choose ``Community AMIs`` from the drop-down and select the AMI (**This AMI is only available in US Regions so make sure you request a spot instance from there!**)
4. Delete the default instance type, click on ``Select`` and select the ``g2.2xlarge`` instance
5. **IMPORTANT** Uncheck the ``Delete`` checkbox under ``EBS Volumes`` so your progress is not deleted when the instance get's terminated.

  **CAEd: LESSON LEARNED: I didn't do this and lost several whole day's worth of trained data.** If you know how to recover the data, after the instance is terminated (and deleted), please let me know so we can update this markdown file to include the steps for gathering that data.

6. Set ``Security Groups`` to ``default``
  **NOTE:** if you cannot connect to your instance on SSH, you may be able to add the security group settings from Term 1 (i.e. Launch Wizard or Jupyter). You can do this after your instance has launched. Then try connecting via SSH again
7. Select your key pair under ``Key pair name`` (if you don't have one create a new key pair) **SAVE THIS PEM file and distribute it if you want to log into your instance from different computers**
8. At the very bottom set ``Request valid until`` to about **24 - 48 hours** (if you're running it while you go to work. I am setting mine to last a week because I am currently anticipating the birth of my child) and set ``Terminate instances at expiration`` as checked (You don't have to do this but keep in mind to receive a very large bill from AWS if you forget to terminate your spot instance because the default value for termination is set to 1 year.)
9. Click ``Launch``, wait until the instance is created and then connect to your instance via ssh

### Logging into your Instance
Follow AWS's instruction for logging into your instance.

**Note:** If you did not add your .pem file to your environment paths, make sure your terminal either references the fullpath to the .pem file or that you are connecting to your instance from the same directory as the .pem file.

### Setting up your environment

1. Clone this repository to your instance
`git clone https://github.com/itscherylanne/TL_model_make`
2. Go into repo directory
`cd TL_model_make`
3. Get updates, setup tensorflow to version 1.4 and check out the TF model creation repository (that works with TF v1.4)
`./01_tf_setup.sh`
4. Download and unzip pre-trained models into the **model** folder
`./02_download_and_unzip_models.sh`
5.  Download TF record files into the **data** folder
`./03_download_TF_records.sh`

###



---------------

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
