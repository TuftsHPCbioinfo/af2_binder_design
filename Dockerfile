FROM tuftsttsrt/miniforge-cuda:24.9.0

# Set labels
LABEL maintainer="Yucheng Zhang <Yucheng.Zhang@tufts.edu>"

# Create a working directory
WORKDIR /opt

# Set environment variables
ENV PATH=/opt/dl_binder_design/af2_initial_guess:$PATH

# Install git
RUN apt-get update && apt-get install -y git \
    && apt-get clean && \
    && rm -rf /var/lib/apt/lists/*

# Download github repo
git clone https://github.com/nrbennet/dl_binder_design
chmod +x /opt/dl_binder_design/af2_initial_guess/*.py

# Install the required conda channels and dependencies into the base environment
RUN conda install -y \
    biopython \
    ml-collections \
    ml_dtypes \
    tensorflow \
    pyrosetta \
    mock \
    -c pytorch \
    -c nvidia \
    -c conda-forge \
    -c defaults && \
    conda clean -afy

# Install pip-based packages into the base environment, including JAX with CUDA support
RUN pip install --find-links https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
    "jax[cuda12_pip]==0.4.20" jaxlib dm-haiku dm-tree

# Clean up unnecessary files
RUN conda clean --all --yes && \
    rm -rf /root/.cache/pip

# Set default command to start bash shell
CMD ["/bin/bash"]