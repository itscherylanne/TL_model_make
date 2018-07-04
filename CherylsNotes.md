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
------------------------
## Commands to upload TF record files to aws

```
scp -i ~/capstone.pem \
  ~/Development/TL_model_make/data/bosch/bosch_train.record  \
  ubuntu@ec2-52-53-215-45.us-west-1.compute.amazonaws.com:~/data

scp -i ~/capstone.pem \
  ~/Development/TL_model_make/data/bosch/bosch_train_14labels.record \
  ubuntu@ec2-52-53-215-45.us-west-1.compute.amazonaws.com:~/data

scp -i ~/capstone.pem \
  ~/Development/TL_model_make/data/dataset-sdcnd-capstone/sim_data.record \
  ubuntu@ec2-52-53-215-45.us-west-1.compute.amazonaws.com:~/data

scp -i ~/capstone.pem \
  ~/Development/TL_model_make/data/dataset-sdcnd-capstone/real_data.record \
  ubuntu@ec2-52-53-215-45.us-west-1.compute.amazonaws.com:~/data

scp -i ~/capstone.pem \
    ~/Development/TL_model_make/data/udacity_label_map.pbtxt \
    ubuntu@ec2-52-53-215-45.us-west-1.compute.amazonaws.com:~/labels

scp -i ~/capstone.pem \
      ~/Development/TL_model_make/data/bosch_14label_map.pbtxt \
      ubuntu@ec2-52-53-215-45.us-west-1.compute.amazonaws.com:~/labels

scp -i ~/capstone.pem \
            ~/Development/TL_model_make/data/coco_label_map.pbtxt \
            ubuntu@ec2-52-53-215-45.us-west-1.compute.amazonaws.com:~/labels

scp -i ~/capstone.pem \
        ~/Development/TL_model_make/config/ssd_inception_v2_coco.config \
        ubuntu@ec2-52-53-215-45.us-west-1.compute.amazonaws.com:~/config/         


scp -i ~/capstone.pem \
    ubuntu@ec2-52-53-215-45.us-west-1.compute.amazonaws.com:~/.bashrc \
       ~/Development/TL_model_make\AWS_bash.txt
```
-----------------------
## labelImg
This is a tool to annotate imagery for the classifier. Tool may be found here:
https://github.com/tzutalin/labelImg

First you will need to check out the git repository


Then you will need to go to that repository directory


Then use the following command to create or run a docker container with the labelImg program
```
sudo docker run -it \
--user $(id -u) \
-e DISPLAY=unix$DISPLAY \
--workdir=$(pwd) \
--volume="/home/$USER:/home/$USER" \
--volume="/etc/group:/etc/group:ro" \
--volume="/etc/passwd:/etc/passwd:ro" \
--volume="/etc/shadow:/etc/shadow:ro" \
--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
-v /tmp/.X11-unix:/tmp/.X11-unix \
tzutalin/py2qt4
```

Then use the following command to create the program (you can skip this if you already done so)
```
make qt4py2
```

The call the program
```
./labelImg.py
```
----------------------------
## Bosch Datasets
Note that the bosch data set is in parts. You will need to put the partial zip files in a common directory and fuse them together.

Link to datasets:
https://hci.iwr.uni-heidelberg.de/node/6132/download/4230201a07fab2fb9acdcee4f2dd9cd8

**NOTE**: This link will be accessible until Wed, 07/04/2018 - 07:54. If you need
access after the link expires, don't hesitate to revisit the download page on
https://hci.iwr.uni-heidelberg.de/

**Training Data**
```
cd /home/cheryl/Development/TL_data/bosch/train
cat dataset_train_rgb.zip.* > dataset_train_rgb.zip
```
**Testing Data**
```
cd /home/cheryl/Development/TL_data/bosch/test
cat dataset_test_rgb.zip.* > dataset_test_rgb.zip
```


**convert dataset to TF Record file**
Bosch Training Set
```
python create_tf_record.py \
 --data_dir=/home/cheryl/Development/TL_model_make/data/bosch/train/train.yaml \
  --output_path=/home/cheryl/Development/TL_model_make/data/bosch/bosch_train_14labels.record \
   --label_map_path=/home/cheryl/Development/TL_model_make/data/bosch_label_map.pbtxt
```
Bosch Testing Set
```
python create_tf_record.py \
 --data_dir=/home/cheryl/Development/TL_model_make/data/bosch/test/test.yaml \
  --output_path=/home/cheryl/Development/TL_model_make/data/bosch/bosch_test_14labels.record \
   --label_map_path=/home/cheryl/Development/TL_model_make/data/bosch_label_map.pbtxt
```
-----
--------------
ProtoBuf 3.4
https://github.com/google/protobuf/releases/tag/v3.4.0
