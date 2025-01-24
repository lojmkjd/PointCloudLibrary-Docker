# Sst the version of Ubuntu.
ARG UBUNTU_VERSION=20.04

# Use the latest version of cuda.
ARG CUDA_VERSION=12.6.3

FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}

# Eigen patch (https://eigen.tuxfamily.org/bz/show_bug.cgi?id=1462) to fix issue mentioned
# in https://github.com/PointCloudLibrary/pcl/issues/3729 is available in Eigen 3.3.7.
# Not needed from 20.04 since it is the default version from apt
ARG EIGEN_MINIMUM_VERSION=3.3.7

# Check https://packages.ubuntu.com/search?suite=all&arch=any&searchon=names&keywords=libvtk%20qt-dev
# for available packages for chosen UBUNTU_VERSION
ARG VTK_VERSION=7

# Use the latest version of CMake by adding the Kitware repository if true.
# Suggest that you'd better use the latest version of CMake when using the pcl,
# to void compiling errors.
ARG USE_LATEST_CMAKE=True

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -V install -y \
      build-essential \
      linux-libc-dev \
      clang \
      clang-tidy \
      libbenchmark-dev \
      libblas-dev \
      libboost-all-dev \
      libcjson-dev \
      libflann-dev \
      libglew-dev \
      freeglut3-dev \
      libgtest-dev \
      libomp-dev \
      libopenni-dev \
      libopenni2-dev \
      libpcap-dev \
      libproj-dev \
      libqhull-dev \
      libusb-1.0-0-dev \
      libusb-dev \
      libudev-dev \
      libvtk${VTK_VERSION}-qt-dev \
      libxmu-dev \
      libxi-dev \
      lsb-release \
      mono-complete \
      mpi-default-dev \
      software-properties-common \
      wget \
      xvfb \
 && if [ "$USE_LATEST_CMAKE" = true ] ; then \
      cmake_ubuntu_version=$(lsb_release -cs) ; \
      if ! wget -q --method=HEAD "https://apt.kitware.com/ubuntu/dists/$cmake_ubuntu_version/Release"; then \
        ubuntu_version=$(lsb_release -sr) ; \
        if dpkg --compare-versions ${ubuntu_version} ge 22.04; then \
          cmake_ubuntu_version="jammy" ; \
        elif dpkg --compare-versions ${ubuntu_version} ge 20.04; then \
          cmake_ubuntu_version="focal" ; \
        else \
          cmake_ubuntu_version="bionic" ; \
        fi ; \
      fi ; \
      wget -qO - https://apt.kitware.com/kitware-archive.sh | bash -s -- --release $cmake_ubuntu_version ; \
      apt-get update ; \
    fi \
 && apt-get -V install -y cmake \
 && rm -rf /var/lib/apt/lists/*

# Use libeigen3-dev if it meets the minimal version.
# In most cases libeigen3-dev is already installed as a dependency of libvtk6-dev & libvtk7-dev, but not in every case (libvtk9 doesn't seem to have this dependency),
# so install it from apt if the version is sufficient.
RUN if dpkg --compare-versions $(apt-cache show --no-all-versions libeigen3-dev | grep -P -o 'Version:\s*\K.*') ge ${EIGEN_MINIMUM_VERSION}; then \
      apt-get -V install -y libeigen3-dev ; \
    else \
      wget -qO- https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_MINIMUM_VERSION}/eigen-${EIGEN_MINIMUM_VERSION}.tar.gz | tar xz \
      && cd eigen-${EIGEN_MINIMUM_VERSION} \
      && mkdir build \
      && cd build \
      && cmake .. \
      && make -j$(nproc) install \
      && cd ../.. \
      && rm -rf eigen-${EIGEN_MINIMUM_VERSION}/ ; \
    fi
