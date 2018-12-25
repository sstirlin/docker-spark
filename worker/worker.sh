#!/bin/bash

. "/spark/sbin/spark-config.sh"

. "/spark/bin/load-spark-env.sh"

mkdir -p $SPARK_WORKER_LOG

# activate py 3.7 in conda environment
source /miniconda3/etc/profile.d/conda.sh
conda activate py37

export SPARK_HOME=/spark
export PYSPARK_DRIVER_PYTHON=ipython
export PYSPARK_PYTHON=python

ln -sf /dev/stdout $SPARK_WORKER_LOG/spark-worker.out

/spark/sbin/../bin/spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER >> $SPARK_WORKER_LOG/spark-worker.out
