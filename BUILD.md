BUILD
=====

sudo WITH_LIBELF=yes CUDA_DIR=/usr/local/cuda-10.0 TAG=lp150 make rpm
sudo rpm -ivh dist/*.rpm
