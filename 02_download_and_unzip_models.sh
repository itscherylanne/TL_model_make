echo "[02_download_and_unzip_models.sh] Setting current directory to models"
cd models

echo "[02_download_and_unzip_models.sh] Downloading ssd_mobilenet_v1_coco_11_06_2017"
wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_coco_11_06_2017.tar.gz
echo "[02_download_and_unzip_models.sh] Unzipping ssd_mobilenet_v1_coco_11_06_2017"
tar -xzf ssd_mobilenet_v1_coco_11_06_2017.tar.gz

echo "[02_download_and_unzip_models.sh] Downloading ssd_inception_v2_coco_11_06_2017"
wget http://download.tensorflow.org/models/object_detection/ssd_inception_v2_coco_11_06_2017.tar.gz
echo "[02_download_and_unzip_models.sh] Unzipping ssd_inception_v2_coco_11_06_2017"
tar -xzf ssd_inception_v2_coco_11_06_2017.tar.gz

echo "[02_download_and_unzip_models.sh] Downloading rfcn_resnet101_coco_11_06_2017"
wget http://download.tensorflow.org/models/object_detection/rfcn_resnet101_coco_11_06_2017.tar.gz
echo "[02_download_and_unzip_models.sh] Unzipping rfcn_resnet101_coco_11_06_2017"
tar -xzf rfcn_resnet101_coco_11_06_2017.tar.gz

echo "[02_download_and_unzip_models.sh] Downloading faster_rcnn_resnet101_coco_11_06_2017"
wget http://download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_11_06_2017.tar.gz
echo "[02_download_and_unzip_models.sh] Unzipping faster_rcnn_resnet101_coco_11_06_2017"
tar -xzf faster_rcnn_resnet101_coco_11_06_2017.tar.gz

echo "[02_download_and_unzip_models.sh] Downloading faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017"
wget http://download.tensorflow.org/models/object_detection/faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017.tar.gz
echo "[02_download_and_unzip_models.sh] Unzipping faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017"
tar -xzf faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017.tar.gz

echo "[02_download_and_unzip_models.sh] Returning to parent folder."
cd ..

echo "[02_download_and_unzip_models.sh] Exiting."
