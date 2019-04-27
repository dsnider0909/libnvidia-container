BUILD
=====

Depend modules
sudo zypper in libcap-devel libelf-devel libseccomp-devel rpmbuild rpmlint

For openSUSE Leap 15.0
sudo WITH_LIBELF=yes CUDA_DIR=/usr/local/cuda-10.0 TAG=lp150 make rpm

For SLES 12SP3
sudo WITH_LIBELF=yes CUDA_DIR=/usr/local/cuda-9.2 TAG=sl12sp3 make rpm

Install
=======
sudo rpm -ivh dist/*.rpm
