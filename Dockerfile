FROM ubuntu:16.04

# ==== Install necessary libraries for gem5 and rocm ====
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-multilib \
    g++-multilib \
    git \
    m4 \
    scons \
    zlib1g \
    zlib1g-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libprotoc-dev \
    libgoogle-perftools-dev \
    python-dev \
    python \
    wget \
    libpci3 \
    libelf1 \
    vim


# ==== Install all rocm related files ====
ARG rocm_ver=1.6.0

RUN wget -qO- repo.radeon.com/rocm/archive/apt_${rocm_ver}.tar.bz2 \
    | tar -xjv \
    && cd apt_${rocm_ver}/debian/pool/main/ \
    && dpkg -i h/hsakmt-roct-dev/* \
    && dpkg -i h/hsa-ext-rocr-dev/* \
    && dpkg -i h/hsa-rocr-dev/* \
    && dpkg -i r/rocm-utils/* \
    && dpkg -i h/hcc/* \
    && dpkg -i h/hip_base/* \
    && dpkg -i h/hip_hcc/* \
    && dpkg -i h/hip_samples/*

ENV ROCM_PATH /opt/rocm
ENV HCC_HOME ${ROCM_PATH}/hcc
ENV HSA_PATH ${ROCM_PATH}/hsa
ENV HIP_PLATFORM hcc
ENV PATH ${ROCM_PATH}/bin:${PATH}

WORKDIR /sim   # /sim will be our home

# ==== Download gem5, apply patch, build GCN3_X86 ====
# gem5 needs paths updated in configs/examples/apu_se.py and syscalls ignored in src/arch/x86/linux/process.cc 
RUN git clone https://gem5.googlesource.com/amd/gem5 -b agutierr/master-gcn3-staging   # download gem5
RUN git clone https://github.com/SwernerHD/gem5_apu_patch.git  			   # download patch
RUN mv gem5_apu_patch/gem5_apu.patch .     # move actual patch file to current directory
RUN patch -s -p0 < gem5_apu.patch	   # apply patch to gem5 
RUN rm -r gem5_apu_patch		   # clean up 
RUN rm gem5_apu.patch			   # clean up 

# ==== Install and compile ComputeApps ====
# Install some requires packages
RUN apt-get update && apt-get install -y \
    libomp-dev \
    libopenmpi-dev

# here patch might be needed if apps don't compile out of the box 

RUN git clone https://github.com/AMDComputeLibraries/ComputeApps.git



# other stuff from kyle 
CMD bash

