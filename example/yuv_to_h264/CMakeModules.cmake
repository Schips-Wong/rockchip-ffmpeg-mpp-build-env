
## 额外的C编译选项
add_c_flag("-Wall -g")
## 额外的C++编译选项
add_cxx_flag("-Wall -std=c++11")

add_module_src("./")
add_module_head("../../install/include")

## 额外的链接选项
#add_ld_flag("-lpthread")
#add_ld_flag("-lm")

## 额外的宏定义
#add_define("VERSION=1.0")

## 额外的链接目录
add_lib_path_for_link("../../install/lib")

## 额外的链接库
add_lib_for_link("m")
add_lib_for_link("pthread")
add_lib_for_link("rga")
add_lib_for_link("rockchip_mpp")
add_lib_for_link("avformat")
add_lib_for_link("avcodec")
add_lib_for_link("avutil")
add_lib_for_link("swresample")
add_lib_for_link("swscale")
add_lib_for_link("postproc")
add_lib_for_link("drm")




## 指定的源文件目录是否加入头文件跟踪
#set (INLUCDE_CODE_DIR ON) # ON or OFF

## 指定的交叉工具链
#set (CROSS_COMPILE "arm-linux-")

