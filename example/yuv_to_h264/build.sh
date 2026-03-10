#!/bin/bash

## 指定的输出文件名
APP_NAME=yuv_to_h264

## 自动获取工具链前缀
HOST_TC=`cat ../../build.sh | grep -v "#" | grep "HOST_TC=" | head -n 1 | awk -F= '{print$2}'`
if [ ! -z "$HOST_TC" ];then
	HOST_TC_=${HOST_TC}-
fi

HOST_TC_=aarch64-linux-gnu-


# 指定输出目录(主目录是在编译目录中，需要使用"../"或者"绝对路径")
OUTPUT_DIR=`pwd`/out



BUILD_DIR=./.build

rm $BUILD_DIR -rf
mkdir $BUILD_DIR -p

cc_arg=""
if [ ! -z "$HOST_TC_" ];then
	cc_arg="-DCROSS_COMPILE=$HOST_TC_"
fi

bash <<EOF
cd $BUILD_DIR
cmake .. -DOUTPUT_APPNAME=$APP_NAME -DOUTPUT_DIRNAME=${OUTPUT_DIR}  "$cc_arg"
make -j16
${HOST_TC_}strip  $OUTPUT_DIR/$APP_NAME
EOF
