FROM ubuntu:20.04 AS build
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
  && apt-get install -y \
    build-essential pkg-config git \
    libssl-dev libcurl4-openssl-dev nginx \
    swig sqlite3 bison flex unzip \
    libsqlite3-dev libtiff-dev libnetcdf-dev libzstd-dev \
    python3-dev python3-pip \
  && cd /usr/local/bin \
  && ln -s $(readlink -f $(which python3)) python \
  && cd /bin \
  && ln -s $(readlink -f $(which python3)) python \
  && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED 1
ENV CPUS 2

COPY assets/* /usr/src/

RUN cd /usr/src && tar -xzf hdf-4.2.15.tar.gz && cd hdf-4.2.15 \
  && export CFLAGS="-fPIC" && export CXXFLAGS="-fPIC" && ./configure --disable-netcdf --disable-fortran \
  && make && make install && cp -R hdf4 /opt \
  && ldconfig

RUN cd /usr/src && tar -jxf geos-3.8.1.tar.bz2 && cd geos-3.8.1 \
  && ./configure && make && make install \
  && ldconfig

RUN cd /usr/src && tar -xzf proj-7.2.0.tar.gz && cd proj-7.2.0 \
  && ./configure && make && make install \
  && ldconfig

RUN PIP_ROOT_USER_ACTION=ignore pip \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org \
    --no-cache-dir install --upgrade pip
RUN PIP_ROOT_USER_ACTION=ignore pip \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org \
    --no-cache-dir install \
      cython \
      gunicorn \
      numpy \
  && PIP_ROOT_USER_ACTION=ignore pip \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org \
    --no-cache-dir install \
      "setuptools~=57.5.0" \
      "h5py>=2.9" \
      "pandas>=0.24" \
      "click==7.1.2" \
      "flask==2.0.3" \
      "python-cmr>=0.4" \
      "requests>=2" \
      "pycksum>=0.4.3"

RUN cd /usr/src && tar -xzf gdal-3.2.0.tar.gz && cd gdal-3.2.0 \
  && ./configure --with-hdf4=/opt/hdf4 --with-python --with-netcdf --with-liblzma --with-libzstd \
  && CPPFLAGS=-I/opt/hdf4/include make && make install \
  && ldconfig

RUN PIP_ROOT_USER_ACTION=ignore pip \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org \
    --no-cache-dir install \
      gdal==3.2.0

FROM build AS production
ARG USERNAME=worker
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --no-log-init --uid $USER_UID --gid $USER_GID -m $USERNAME
