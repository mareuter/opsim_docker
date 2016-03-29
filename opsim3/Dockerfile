FROM centos:7
MAINTAINER Michael Reuter <mareuter@lsst.org>

# Need to install:
# curl for package grabbing
# bzip2 and python for the EUPS conda install
# nano because we need to edit the config files
# tcsh is needed by modifySchema
RUN yum install -y \
  bzip2 \
  nano \
  tcsh \
  git

# Create user
RUN /usr/sbin/adduser --comment ""--create-home --home-dir /home/opsim --shell /bin/bash opsim
USER opsim
ENV HOME /home/opsim
WORKDIR /home/opsim

# Download and install Miniconda
RUN curl -Ok https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN bash Miniconda-latest-Linux-x86_64.sh -b -p miniconda
RUN rm Miniconda-latest-Linux-x86_64.sh

# Download and configure OpSim
RUN bash -c "export PATH=/home/opsim/miniconda/bin:$PATH \
  && conda config --add channels http://lsst-web.ncsa.illinois.edu/~mareuter/conda/dev \
  && conda config --add channels http://eupsforge.net/conda/dev \
  && conda install lsst-sims-operations \
  && source eups-setups.sh \
  && setup sims_operations \
  && opsim-configure.py --all -R ${HOME}/opsim-config \
  && rm -rf miniconda/pkgs"

# Download the OpSim configuration
RUN git clone https://github.com/lsst-sims/opsim3_config.git conf

# Make area to run OpSim in
RUN mkdir /home/opsim/runs
WORKDIR /home/opsim/runs
RUN mkdir log output

# Mount point for OpSim logs and SQLite output
VOLUME ["/home/opsim/runs/log", \
        "/home/opsim/runs/output"]

# Now that we're done, clean up!
USER root
RUN yum erase -y \
  bzip2 \
  && yum clean all

# Add in startup script
USER opsim
ADD ./startup.sh /home/opsim/startup.sh
CMD ["/bin/bash", "/home/opsim/startup.sh"]