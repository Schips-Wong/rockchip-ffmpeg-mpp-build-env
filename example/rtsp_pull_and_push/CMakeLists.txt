cmake_minimum_required(VERSION 3.1)

project(quick-cpp)

# 可在外部指定下列选项
set (INLUCDE_CODE_DIR OFF)## 指定的源文件目录是否加入头文件跟踪

## 指定的输出文件名
set(OUTPUT_APPNAME)
# 指定输出目录(默认在out目录,主目录是在编译目录中，需要使用"../"或者"绝对路径")
set (OUTPUT_DIRNAME)

set (add_c_flags  ) ## 额外的C编译选项
set (add_cxx_flags) ## 额外的C++编译选项
set (add_ldflags)   ## 额外的链接选项
set (add_defines)   ## 额外的宏定义选项
set (CROSS_COMPILE) ## 指定的交叉工具链

set(src_dirs) # 源码路径
set(inc_dirs) # 头文件路径
set(lib_dirs) # 库目录
set(libs_name) # 库名

#set(CMAKE_VERBOSE_MAKEFILE ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -O0 -fPIC -fpermissive -Wall -Wno-packed-bitfield-compat")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lstdc++ -D__UAPI_DEF_IF_IFREQ=1")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0 ")

if (CONFIG_VERSION_COMMITID)
add_definitions(-DCONFIG_VERSION_COMMITID=${CONFIG_VERSION_COMMITID})
endif()
if (CONFIG_VERSION_COMMITDAY)
add_definitions(-DCONFIG_VERSION_COMMITDAY=${CONFIG_VERSION_COMMITDAY})
endif()
if (CONFIG_VERSION_COMMITHOUR)
add_definitions(-DCONFIG_VERSION_COMMITHOUR=${CONFIG_VERSION_COMMITHOUR})
endif()

set(CXX_STANDARD_REQUIRED ON)


define_property(GLOBAL
    PROPERTY GLOBAL_INC_DIRS
    BRIEF_DOCS "A global list for head dir added"
    FULL_DOCS  "A global list for head dir added"
)
define_property(GLOBAL
    PROPERTY GLOBAL_SRC_DIRS
    BRIEF_DOCS "A global list for source dir added"
    FULL_DOCS  "A global list for source dir added"
)
define_property(GLOBAL
    PROPERTY GLOBAL_C_FLAG
    BRIEF_DOCS "A global list for c flag added"
    FULL_DOCS  "A global list for c flag added"
)
define_property(GLOBAL
    PROPERTY GLOBAL_CXX_FLAG
    BRIEF_DOCS "A global list for c++ flag added"
    FULL_DOCS  "A global list for c++ flag added"
)
define_property(GLOBAL
    PROPERTY GLOBAL_LIB_NAME
    BRIEF_DOCS "A global list for lib added"
    FULL_DOCS  "A global list for lib added"
)
define_property(GLOBAL
    PROPERTY GLOBAL_LIB_PATH
    BRIEF_DOCS "A global list for lib path added"
    FULL_DOCS  "A global list for lib path added"
)
define_property(GLOBAL
    PROPERTY GLOBAL_LD_FLAG
    BRIEF_DOCS "A global list for ld flag added"
    FULL_DOCS  "A global list for ld flag added"
)


# 定义函数
function(add_module dir_path)
    message(STATUS "---------------------")
    message(STATUS "ADD 3rd module :  ${dir_path}")
    set(this_module_path "${dir_path}")
    include("${dir_path}/module.cmake")
endfunction()

function (add_module_head dir_path)
    message(STATUS "  HEAD         :  ${dir_path}")
    get_property(tmp_val GLOBAL PROPERTY GLOBAL_INC_DIRS)
    set_property(GLOBAL PROPERTY GLOBAL_INC_DIRS "${tmp_val};${dir_path}")
endfunction()
function(add_module_src dir_path)
    get_property(tmp_val GLOBAL PROPERTY GLOBAL_SRC_DIRS)
    set_property(GLOBAL PROPERTY GLOBAL_SRC_DIRS "${tmp_val};${dir_path}")
    message(STATUS "  SRC          :  ${dir_path}")
endfunction()

function (add_c_flag c_flag)
    message(STATUS "  C  FALG      :  ${c_flag}")
    get_property(tmp_val GLOBAL PROPERTY GLOBAL_C_FLAG)
    set_property(GLOBAL PROPERTY GLOBAL_C_FLAG "${tmp_val};${c_flag}")
endfunction()
function (add_cxx_flag cxx_flag)
    message(STATUS "  CXX FALG     :  ${cxx_flag}")
    get_property(tmp_val GLOBAL PROPERTY GLOBAL_CXX_FLAG)
    set_property(GLOBAL PROPERTY GLOBAL_CXX_FLAG "${tmp_val};${cxx_flag}")
endfunction()

function (add_lib_for_link lib_name)
    message(STATUS "  LIB NAME     :  ${lib_name}")
    get_property(tmp_val GLOBAL PROPERTY GLOBAL_LIB_NAME)
    set_property(GLOBAL PROPERTY GLOBAL_LIB_NAME "${tmp_val};${lib_name}")
endfunction()
function (add_lib_path_for_link lib_dir)
    message(STATUS "  LIB PATH     :  ${lib_dir}")
    get_property(tmp_val GLOBAL PROPERTY GLOBAL_LIB_PATH)
    set_property(GLOBAL PROPERTY GLOBAL_LIB_PATH "${tmp_val};${lib_dir}")
endfunction()

function (add_ld_flag ld_flag)
    message(STATUS "  LD FLAG      :  ${ld_flag}")
    get_property(tmp_val GLOBAL PROPERTY GLOBAL_LD_FLAG)
    set_property(GLOBAL PROPERTY GLOBAL_LD_FLAG "${tmp_val};${ld_flag}")
endfunction()
function (add_define cc_define)
    message(STATUS "  DEFINE       :  ${cc_define}")
    get_property(tmp_val GLOBAL PROPERTY GLOBAL_CC_DEFINE)
    set_property(GLOBAL PROPERTY GLOBAL_CC_DEFINE "${tmp_val};${cc_define}")
endfunction()

message(STATUS "---------------------")

include(CMakeModules.cmake)

get_property(inc_dirs GLOBAL PROPERTY GLOBAL_INC_DIRS)
get_property(src_dirs GLOBAL PROPERTY GLOBAL_SRC_DIRS)

get_property(add_c_flags GLOBAL PROPERTY GLOBAL_C_FLAG)
get_property(add_cxx_flags GLOBAL PROPERTY GLOBAL_CXX_FLAG)

get_property(libs_name GLOBAL PROPERTY GLOBAL_LIB_NAME)
get_property(lib_dirs GLOBAL PROPERTY GLOBAL_LIB_PATH)

get_property(add_ldflags GLOBAL PROPERTY GLOBAL_LD_FLAG)
get_property(add_defines GLOBAL PROPERTY GLOBAL_CC_DEFINE)



###################### 请勿轻易修改 ######################
message(STATUS "-------------------------")

# 遍历指定的源目录
if (src_dirs)
set(ALL_SRC_FILES "")
foreach(sdir ${src_dirs})
    #set(ROOT_PROJ ${CMAKE_CURRENT_SOURCE_DIR})
    #exec_program("cd ${ROOT_PROJ}/; find ${sdir}/ -maxdepth 1 -mindepth 1 -type d 2>/dev/null | grep -v '.git' | xargs"  WORKING_DIRECTORY ${sdir} OUTPUT_VARIABLE DIR_STRING)
    set(DIR_STRING ${sdir})
    aux_source_directory(${sdir}/. ALL_SRC_FILES)
    message(STATUS "[+] src-dir : ${DIR_STRING}")
    # 如果允许INLUCDE_CODE_DIR，那么源文件目录也加入头文件跟踪
    if (INLUCDE_CODE_DIR)
        include_directories( ${DIR_STRING})
        message(STATUS "[+] inc-dir : ${DIR_STRING}")
    endif()
endforeach()
message(STATUS "-------------------------")
endif()

# 遍历指定的头目录
if (inc_dirs)
foreach(sdir ${inc_dirs})
    set(DIR_STRING ${sdir})
    include_directories( ${DIR_STRING})
    message(STATUS "[+] inc-dir : ${DIR_STRING}")
endforeach()
message(STATUS "-------------------------")
endif()

# 添加C编译选项
if (add_c_flags)
foreach(c_flags ${add_c_flags})
    message(STATUS "[+]  c-cfgs : ${c_flags}")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${c_flags}")
endforeach()
    message(STATUS "-------------------------")
endif()
# 添加CXX编译选项
if (add_cxx_flags)
foreach(cxx_flags ${add_cxx_flags})
    message(STATUS "[+] cx-cfgs : ${cxx_flags}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${cxx_flags}")
endforeach()
    message(STATUS "-------------------------")
endif()

if (add_defines)
foreach(d_define ${add_defines})
    message(STATUS "[+] define  : ${d_define}")
    add_definitions("-D${d_define}")
endforeach()
message(STATUS "-------------------------")
endif()
# 遍历指定的库目录
if(lib_dirs)
foreach(sdir ${lib_dirs})
    set(DIR_STRING ${sdir})
    link_directories( ${DIR_STRING})
    message(STATUS "[+] lib-dir ${DIR_STRING}")
endforeach()
message(STATUS "-------------------------")
endif()

# 添加指定的库名
if(libs_name)
foreach(sdir ${libs_name})
    set(DIR_STRING "-l${sdir}")
    list(APPEND ALL_LIB_NAME ${DIR_STRING})
    message(STATUS "[+] lib     ${sdir}")
endforeach()
message(STATUS "-------------------------")
endif()

# 添加LD选项
set(ALL_LDFLAGS "")
if (add_ldflags)
foreach(ld_flags ${add_ldflags})
    message(STATUS "[+] ld-cfgs : ${ld_flags}")
    set(ALL_LDFLAGS "${ALL_LDFLAGS} ${ld_flags}")
endforeach()
    message(STATUS "-------------------------")
endif()

# 指定工具链
if (CROSS_COMPILE)
    set(CMAKE_C_COMPILER   "${CROSS_COMPILE}gcc")
    set(CMAKE_CXX_COMPILER "${CROSS_COMPILE}g++")
    message(STATUS "using CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
    message(STATUS "using CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
    message(STATUS "-------------------------")
endif()


add_executable(program ${ALL_SRC_FILES})

###   if(NOT CMAKE_BUILD_TYPE)
###       set(CMAKE_BUILD_TYPE MinSizeRel)
###   endif()
###
###   message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")


#string(TIMESTAMP COMPILE_TIME %Y%m%d_%H%M%S)
#string(TIMESTAMP COMPILE_TIME %Y%m%d_%H)

# 指定输出文件名
if (NOT OUTPUT_APPNAME)
    set(OUTPUT_APPNAME "quick-cpp")
endif()
# 指定输出目录(默认在out目录)
if (NOT OUTPUT_DIRNAME)
    SET(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/out)
else()
    SET(EXECUTABLE_OUTPUT_PATH ${OUTPUT_DIRNAME})
endif()

set(target_name "${OUTPUT_APPNAME}")
SET_TARGET_PROPERTIES (program PROPERTIES OUTPUT_NAME "${target_name}")
target_link_libraries(program ${ALL_LIB_NAME})

#  message(STATUS "CMAKE_CURRENT_SOURCE_DIR: ${TOP}")
#  ##可以使用配置文件进行加载不同的编译链
#  ## 例如:
#  ##      toolchain.make
#  ##      文件内容：
#  ##           set(CMAKE_C_COMPILER gcc)
#  ##           set(CMAKE_CXX_COMPILER g++)
#  ##
#  include(${TOP}/tools/toolchain.cmake)
