#!/bin/bash

export SPARK_MASTER_HOST=`hostname`

. "/spark/sbin/spark-config.sh"

. "/spark/bin/load-spark-env.sh"

mkdir -p $SPARK_MASTER_LOG

# activate py 3.7 in conda environment
source /miniconda3/etc/profile.d/conda.sh
conda activate py37

export SPARK_HOME=/spark
export PYSPARK_DRIVER_PYTHON=ipython
export PYSPARK_PYTHON=python

ln -sf /dev/stdout $SPARK_MASTER_LOG/spark-master.out

cd /spark/bin && /spark/sbin/../bin/spark-class org.apache.spark.deploy.master.Master \
    --ip $SPARK_MASTER_HOST --port $SPARK_MASTER_PORT --webui-port $SPARK_MASTER_WEBUI_PORT >> $SPARK_MASTER_LOG/spark-master.out
