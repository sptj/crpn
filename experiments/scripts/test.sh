#!/bin/bash
set -x
set -e

export PYTHONUNBUFFERED="True"

NET=$1
MODEL=$2
DATASET=$3

array=( $@ )
len=${#array[@]}
EXTRA_ARGS=${array[@]:3:$len}
EXTRA_ARGS_SLUG=${EXTRA_ARGS// /_}

case $DATASET in
  voc_2005)
    TRAIN_IMDB="voc_2005_trainval"
    TEST_IMDB="voc_2005_test"
    ;;
  voc_2006)
    TRAIN_IMDB="voc_2006_trainval"
    TEST_IMDB="voc_2006_test"
    ;;
  voc_2007)
    TRAIN_IMDB="voc_2007_trainval"
    TEST_IMDB="voc_2007_test"
    ;;
  voc_2008)
    TRAIN_IMDB="voc_2008_trainval"
    TEST_IMDB="voc_2008_test"
    ;;
  *)
    echo "No dataset given"
    exit
    ;;
esac

LOG="experiments/logs/test_${NET}.`date +'%Y-%m-%d_%H-%M-%S'`"
exec &> >(tee -a "$LOG")
echo Logging output to "$LOG"

time ./tools/test_net.py --gpu 0 \
  --def models/${NET}/test.pt \
  --net ${MODEL} \
  --imdb ${TEST_IMDB} \
  --cfg models/${NET}/config.yml \
  ${EXTRA_ARGS}
