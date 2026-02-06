# Rockchip FFmpeg build env

为Rockchip编译带有硬件编解码支持的FFmpeg。

已经在x86机器上的Ubuntu 18.04完成交叉编译，使用的工具链为`gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu`

## 用法

直接执行`./build.sh`即可。

编译结果在`./install`目录中

如果meson或者ninja没有安装，可以执行`./update_meson_and_ninja.sh`安装
