echo "[01_tf_setup.sh] Updating environment and installing dask."

sudo apt-get update
pip install --upgrade dask

echo "[01_tf_setup.sh] installing tensorflow and dependencies."
pip install tensorflow-gpu==1.4
sudo apt-get install protobuf-compiler python-pil python-lxml python-tk

echo "[01_tf_setup.sh] setting up local tensorflow folder structure."
mkdir tensorflow
cd tensorflow

echo "[01_tf_setup.sh] cloning TF models repository."
git clone https://github.com/tensorflow/models.git

echo "[01_tf_setup.sh] Reverting to f7e99c0 version to work with TF v1.4."
cd models
git checkout f7e99c0

echo "[01_tf_setup.sh] Setting path."
cd research
protoc object_detection/protos/*.proto --python_out=.
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

echo "[01_tf_setup.sh] Testing model builder."
python object_detection/builders/model_builder_test.py

echo "[01_tf_setup.sh] returning to original folder."
cd ../../..

echo "[01_tf_setup.sh] Exiting Script."
