# 工具链前缀
HOST_TC=aarch64-linux-gnu
if [ -z "$HOST_TC" ];then
	CROCOSS_TC=""
else
	CROCOSS_TC=${HOST_TC}-
fi


# 源码下载路径
MPP_URL=https://gitee.com/nyanmisaka/mpp
RGA_URL=https://gitee.com/nyanmisaka/rga
FMP_URL=https://gitee.com/nyanmisaka/ffmpeg-rockchip

ARM_GCC=${CROCOSS_TC}gcc
ARM_GXX=${CROCOSS_TC}g++
ARM_AR=${CROCOSS_TC}ar
ARM_STRIP=${CROCOSS_TC}strip



top_dir=`pwd`
ins_dir=$top_dir/install
src_dir=$top_dir/source 

mkdir -p $src_dir 



function require () {
    echo "Checking [$1]"
    command -v $1 >/dev/null 2>&1 || { echo >&2 "Aborted : Require \"$1\" but not found."; exit 1; }
}

require cmake
require ninja
require meson
require make
require git


mk_rkmpp()
{
	cd $src_dir
	
	git clone -b jellyfin-mpp --depth=1 $MPP_URL   rkmpp

	cd rkmpp
(
cat <<EOF
	rm -rf rkmpp_build
	mkdir -p rkmpp_build
	cd rkmpp_build
	cmake \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DCMAKE_SYSTEM_PROCESSOR=aarch64 \
		-DCMAKE_C_COMPILER=${ARM_GCC} \
		-DCMAKE_CXX_COMPILER=${ARM_GXX} \
		.. \
		-DCMAKE_INSTALL_PREFIX=$ins_dir \
		-DCMAKE_BUILD_TYPE=Release \
		-DBUILD_SHARED_LIBS=ON \
		-DBUILD_TEST=OFF
	make -j $(nproc)
	make install
EOF
) > build.rkmpp.sh
	bash ./build.rkmpp.sh
}

mk_rkrga()
{
	cd $src_dir
	
	git clone -b jellyfin-rga --depth=1 $RGA_URL   rkrga

	cd rkrga

	gen_meson_cc_file

(
cat <<EOF
	rm   -rf rkrga_build
	mkdir -p rkrga_build

	# . 源代码目录，rkrga_build 是构建目录
	meson setup . rkrga_build \
		--cross-file=$src_dir/cross_file_aarch64.txt \
		--prefix=$ins_dir \
		--libdir=lib \
		--buildtype=release \
		--default-library=shared \
		-Dcpp_args=-fpermissive \
		-Dlibdrm=false \
		-Dlibrga_demo=false
	meson configure rkrga_build
	ninja -C rkrga_build install

EOF
) > build.rkrga.sh
	bash ./build.rkrga.sh
}

set_up_for_meson_ninja()
{
	export PATH=~/.local/bin:$PATH
}

# 不能用太老的版本，会引起“error: ‘DRM_FORMAT_INVALID’ undeclared (first use in this function); did you mean ‘DRM_FORMAT_MOD_INVALID’?”错误
#mk_libdrm_legacy()
#{
#	lib_drm_verson=2.4.89
#
#	cd $src_dir
#	
#    if [  -f "libdrm-${lib_drm_verson}.tar.bz2" ];then
#		echo "downed libdrm"
#	else
#		wget https://dri.freedesktop.org/libdrm/libdrm-${lib_drm_verson}.tar.bz2
#	fi
#
#	tar -xvf libdrm-${lib_drm_verson}.tar.bz2
#	cd libdrm-${lib_drm_verson}
#
#(
#cat <<EOF
#     ./configure \
#    --host=${HOST_TC} \
#    --prefix=${ins_dir} \
#    --disable-nouveau \
#    --disable-static \
#    --disable-install-test-programs \
#    --disable-cairo-tests
#
#	make -j $(nproc)
#	make install
#EOF
#) > build.libdrm.sh
#	bash ./build.libdrm.sh
#}

mk_libdrm_meason()
{
	lib_drm_verson=2.4.110

	cd $src_dir

    if [  -f "libdrm-${lib_drm_verson}.tar.xz" ];then
		echo "downed libdrm"
	else
		wget https://dri.freedesktop.org/libdrm/libdrm-${lib_drm_verson}.tar.xz
	fi

	tar -xvf libdrm-${lib_drm_verson}.tar.xz -C $src_dir || exit 
	cd $src_dir/libdrm-${lib_drm_verson}

	gen_meson_cc_file

(
cat <<EOF
    #创建编译目录
	rm -rf   build
    mkdir -p build

    #进入build
    cd build
    meson --prefix=${ins_dir} \
		  --cross-file=$src_dir/cross_file_aarch64.txt \
          -D amdgpu=false \
          -D cairo-tests=false \
          -D etnaviv=false \
          -D etnaviv=false \
          -D exynos=false \
          -D freedreno=false \
          -D freedreno-kgsl=false \
          -D install-test-programs=true \
          -D intel=false \
          -D libkms=false \
          -D man-pages=false \
          -D nouveau=false \
          -D omap=false \
          -D radeon=false \
          -D tegra=false \
          -D udev=false \
          -D valgrind=false \
          -D vc4=false \
          -D vmwgfx=false

	ninja && ninja install
EOF
) > build.libdrm.sh
	bash ./build.libdrm.sh

}


mk_ffmpeg_rk()
{
	mk_libdrm_meason

	cd $src_dir
	
	git clone                 --depth=1 $FMP_URL   ffmpeg

	cd ffmpeg
(
cat <<EOF
	export PKG_CONFIG_PATH=${ins_dir}/lib/pkgconfig/:\$PKG_CONFIG_PATH
	export CC=${ARM_GCC}
	export CXX=${ARM_GXX}
	alias gcc=\$CC
	./configure --target-os=linux \
	--prefix=${ins_dir} --enable-gpl --enable-version3 \
	--enable-libdrm --enable-rkmpp --enable-rkrga \
	--extra-cflags="-I${ins_dir}/include/rockchip -I${ins_dir}/include/rga -I${ins_dir}/include/libdrm" \
	--extra-ldflags="-L${ins_dir}/lib  -lrockchip_mpp -lrga -ldrm" \
	--arch=arm64 --enable-cross-compile --cc=${ARM_GCC} --cxx=${ARM_GXX} --strip=${ARM_STRIP}

	make -j $(nproc)
	make install
EOF
) > build.ffmpeg_rk.sh
	bash ./build.ffmpeg_rk.sh
}

gen_meson_cc_file()
{
(
cat <<EOF
[binaries]
c = '${ARM_GCC}'
cpp = '${ARM_GXX}'
ar = '${ARM_AR}'
strip = '${ARM_STRIP}'

[host_machine]
system = 'linux'
cpu_family = 'aarch64'
cpu = 'aarch64'
endian = 'little'

[properties]
needs_exe_wrapper = true
EOF
)  > $src_dir/cross_file_aarch64.txt
}

set_up_for_meson_ninja

mk_rkmpp
mk_rkrga
mk_ffmpeg_rk
