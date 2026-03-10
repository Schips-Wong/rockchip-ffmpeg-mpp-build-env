# demo

演示如何编译和使用ffmpeg mpp。

```
-I ../install/include -L ../install/lib \
-lpthread -lm \
-lrga -lrockchip_mpp \
-lavformat -lavcodec -lavutil -lswresample -lswscale -lpostproc -ldrm 
```

## 用法

直接进入各例程目录以后执行`./build.sh`即可

编译结果在`./out`目录中


