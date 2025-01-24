# PointCloudLibrary-Docker
用于创建在Windows11上运行的pcl-docker镜像，可以访问宿主机GPU。

## 镜像参数说明

| 参数                  | 默认    | 描述                     |
| --------------------- | ------- | ------------------------ |
| UBUNTU_VERSION        | 20.04   | Ubuntu 版本              |
| EIGEN_MINIMUM_VERSION | 3.3.7   | Eigen 库最低版本         |
| VTk_VERSION           | 7       | VTK 版本                 |
| USE_LATEST_CMAKE      | True   | 是否使用最新版本的 CMake |

## 软件安装目录

| 软件包                                             | 用途                                     |
| -------------------------------------------------- | ---------------------------------------- |
| build-essential、linux-libc-dev、clang、clang-tidy | 编译工具链                               |
| libbenchmark-dev                                   | 代码性能测试                             |
| libblas-dev                                        | 线性代数运算库                           |
| libboost-all-dev                                   | 运行pcl的必须软件包                      |
| libflann-dev                                       | 运行pcl的必须软件包                      |
| libcjson-dev                                       | json文件处理                             |
| libglew-dev                                        | OpenGL和显卡驱动交互自动化               |
| freeglut3-dev                                      | 创建OpenGL渲染窗口                       |
| libgtest-dev                                       | 代码测试                                 |
| libomp-dev                                         | OpenMP开发包，支持多处理系统内存并行编程 |
| mono-complete                                      | 在Linux 上运行和开发 .NET 应用程序       |
| mpi-default-dev                                    | OpenMP开发包，支持分布式系统内存并行编程 |
| libopenni-dev、libopenni2-dev                      | 硬件设备交互                             |
| libpcap-dev                                        | 网络接口数据包捕获                       |
| libproj-dev                                        | 地理空间数据的坐标转换和投影             |
| libqhull-dev                                       | 几何计算                                 |
| libusb-1.0-0-dev、libusb-dev 、libudev-dev         | USB驱动                                  |
| libvtk7-qt-dev                                     | 开发 Qt 5 应用程序时与 OpenGL 集成       |
| lsb-release                                        | 获取 Linux 标准基础（LSB）相关信息       |
| software-properties-common                         | 为系统提供管理软件源和仓库的工具和功能   |
| wget                                               | 从网络上下载文件                         |
| xvfb、libxmu-dev、libxi-dev                        | 提供图形显示环境                         |

## 安装

### 编译镜像

```powershell
docker build --network host -t pcl-env-image:v1.0 .
```

### 创建并运行容器

```powershell
docker run -e DISPLAY=host.docker.internal:0.0 --gpus all -it --name pcl-docker -v /psth/to/your/pcl/:/home/pcl/ pcl-env-image:v1.0 bash
```

### 编译pcl库

本人在编译库（pcl-1.14.0）时遇到无法识别CUDA17的问题，经过查阅和尝试，是因为Ubuntu20.04默认的Ccmake为3.16，二根据Cmake官网的文档，支持CUDA17的Cmake最低版本为3.18，所以这里默认安装最新的Cmake工具。

### 测试X11图形化

```bash
pcl_viewer /home/pcl/test/pcl_logo.pcd
```
