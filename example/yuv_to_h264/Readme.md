# 说明

演示如何编译和使用ffmpeg mpp实现yuv转h264。

## 用法

1. 准备 yuv文件

```bash
# 可以通过ffmpeg 直接转换MP4为yuv文件
ffmpeg -i .\beautlWorld.mp4 -pixel_format yuv420p -s 1280x720 yuv420p.yuv
```

2. 直接执行编译命令`./build.sh`即可生成可执行文件

3. 执行可执行文件即可实现转换
