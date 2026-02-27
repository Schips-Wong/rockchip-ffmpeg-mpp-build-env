# demo

演示如何编译和使用ffmpeg mpp。

```
-I ../install/include -L ../install/lib \
-lpthread -lm \
-lrga -lrockchip_mpp \
-lavformat -lavcodec -lavutil -lswresample -lswscale -lpostproc -ldrm 
```

例程实现了rtsp拉流并重新推送的功能，您可能需要一个额外的rtsp server才能够让代码工作

## 用法

直接执行`./build.sh`即可。

编译结果在`./out`目录中


