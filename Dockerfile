FROM tuftsttsrt/miniforge-cuda:24.9.0

# Set labels
LABEL maintainer="Yucheng Zhang <Yucheng.Zhang@tufts.edu>"

# Create a working directory
WORKDIR /opt

# Set environment variables
ENV PATH=/opt/miniforge/envs/af2_binder_design/bin:/opt/dl_binder_design/af2_initial_guess:$PATH

# Install git
RUN apt-get update && apt-get install -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download github repo
RUN git clone https://github.com/nrbennet/dl_binder_design \
	&& chmod +x /opt/dl_binder_design/af2_initial_guess/*.py
 
# Install the required conda channels and dependencies into the base environment
RUN conda config --add channels https://conda.graylab.jhu.edu \
    && conda config --set channel_priority flexible

WORKDIR /opt/dl_binder_design/include 

RUN conda env create -f af2_binder_design.yml

# Clean up unnecessary files
RUN conda clean --all --yes && \
    rm -rf /root/.cache/pip

# Set default command to start bash shell
CMD ["/bin/bash"]
