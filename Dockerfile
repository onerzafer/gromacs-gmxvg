FROM gromacs/gromacs:2022.2

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
# Note: python3 is already included in the base image
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    texlive \
    texlive-latex-extra \
    git \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install GMXvg and its dependencies
RUN pip3 install --no-cache-dir \
    UtilityLib \
    pandas \
    matplotlib \
    latex \
    GMXvg

# Set up environment variables
ENV PATH="/usr/local/bin:${PATH}"

# Set working directory
WORKDIR /data

# Copy startup script
COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

# Command to run when container starts
CMD ["/usr/local/bin/startup.sh"]
