# Gromacs with GMXvg Container Image

This container image is based on the official [Gromacs Docker image](https://hub.docker.com/r/gromacs/gromacs) and includes [GMXvg](https://github.com/TheBiomics/GMXvg), a tool to plot GROMACS .xvg files.

## Building the Container Image

### Using Docker

To build the container image using Docker, run the following command from the directory containing the Dockerfile:

```bash
docker build -t gromacs-gmxvg .
```

### Using Podman

To build the container image using Podman, run the following command from the directory containing the Dockerfile:

```bash
podman build -t gromacs-gmxvg .
```

## Running the Container

### Using Docker Run

To run the container directly with Docker, use the following command:

```bash
docker run -it --rm -v $(pwd):/data gromacs-gmxvg
```

This will:
- Start an interactive container (`-it`)
- Remove the container when it exits (`--rm`)
- Mount the current directory to `/data` in the container (`-v $(pwd):/data`)
- Use the `gromacs-gmxvg` image

### Using Podman Run

To run the container directly with Podman, use the following command:

```bash
podman run -it --rm -v $(pwd):/data gromacs-gmxvg
```

The options are the same as with Docker.

### Using Docker Compose

If you have Docker Compose available, you can use it to run the container:

1. Make sure you have Docker Compose installed (included with Docker Desktop or can be installed separately)
2. Create a directory for your data:
   ```bash
   mkdir -p data
   ```
3. Start the container using Docker Compose:
   ```bash
   docker compose up -d
   ```

This will:
- Build the Docker image if it doesn't exist
- Start the container in detached mode (`-d`)
- Mount the `./data` directory to `/data` in the container
- Set up Gromacs environment variables (see below)

To stop the container:
```bash
docker compose down
```

### Using Podman Compose

If you have Podman Compose available, you can use it as a drop-in replacement for Docker Compose:

1. Install Podman Compose if not already installed:
   ```bash
   pip install podman-compose
   ```
2. Create a directory for your data:
   ```bash
   mkdir -p data
   ```
3. Start the container using Podman Compose:
   ```bash
   podman-compose up -d
   ```

To stop the container:
```bash
podman-compose down
```

### Using Podman without Compose

If you don't have Podman Compose available, you can still run the container with all the necessary options:

```bash
podman run -it --name gmxvg-container \
  -v ./data:/data \
  -e GMX_MAXBACKUP=-1 \
  -e GMX_USE_OPENCL=auto \
  -e GMX_DISABLE_CUDA_GPU_DETECTION=no \
  -e GMX_OPENCL_DISABLE_COMPATIBILITY_CHECK=no \
  -e GMX_DISABLE_HARDWARE_DETECTION=no \
  -e GMX_DISABLE_SIMD_KERNELS=no \
  -e GMX_DISABLE_CUDA_TIMING=no \
  -e GMX_DISABLE_GPU_DETECTION=no \
  -e GMX_DISABLE_GPU_TIMING=no \
  gromacs-gmxvg /usr/local/bin/startup.sh
```

### Using Apptainer (formerly Singularity)

Apptainer (formerly Singularity) is a container platform designed for high-performance computing environments. It can run Docker containers by pulling them from Docker Hub or other registries.

#### Building from Docker Hub

If the image is available on Docker Hub, you can pull and run it directly:

```bash
# Pull the Docker image
apptainer pull docker://lozalp/gmxvg

# Run the container
apptainer run gmxvg_latest.sif
```

#### Building from a local Docker image

If you've built the Docker image locally, you can convert it to an Apptainer image:

1. First, save the Docker image to a tar file:
   ```bash
   # If using Docker
   docker save gromacs-gmxvg -o gromacs-gmxvg.tar

   # If using Podman
   podman save gromacs-gmxvg -o gromacs-gmxvg.tar
   ```

2. Then, build an Apptainer image from the tar file:
   ```bash
   apptainer build gromacs-gmxvg.sif docker-archive://gromacs-gmxvg.tar
   ```

3. Run the Apptainer container:
   ```bash
   apptainer run --bind $(pwd):/data gromacs-gmxvg.sif
   ```

#### Running with environment variables

To run the Apptainer container with the same environment variables as in the Docker Compose file:

```bash
apptainer run \
  --bind $(pwd)/data:/data \
  --env GMX_MAXBACKUP=-1 \
  --env GMX_USE_OPENCL=auto \
  --env GMX_DISABLE_CUDA_GPU_DETECTION=no \
  --env GMX_OPENCL_DISABLE_COMPATIBILITY_CHECK=no \
  --env GMX_DISABLE_HARDWARE_DETECTION=no \
  --env GMX_DISABLE_SIMD_KERNELS=no \
  --env GMX_DISABLE_CUDA_TIMING=no \
  --env GMX_DISABLE_GPU_DETECTION=no \
  --env GMX_DISABLE_GPU_TIMING=no \
  gromacs-gmxvg.sif
```

## Accessing the Container Terminal

### When Using Docker Run

When you run the container using `docker run -it` as shown above, you'll immediately get access to the container's terminal. The `-it` flags ensure that the container is interactive and has a TTY (terminal) attached.

### When Using Podman Run

Similarly, when you run the container using `podman run -it`, you'll immediately get access to the container's terminal. The behavior is identical to Docker.

### When Using Docker Compose

If you started the container in detached mode using Docker Compose (`docker compose up -d`), you can access the terminal with the following command:

```bash
docker exec -it gmxvg-container bash
```

This will:
- Connect to the running container named `gmxvg-container`
- Open an interactive bash shell (`-it` flags)
- Allow you to run commands inside the container

### When Using Podman Compose

If you started the container in detached mode using Podman Compose (`podman-compose up -d`), you can access the terminal with the following command:

```bash
podman exec -it gmxvg-container bash
```

The behavior is identical to Docker Compose.

### When Using Podman without Compose

If you started the container using `podman run` without the `-it` flags or with the `-d` flag, you can access the terminal with:

```bash
podman exec -it gmxvg-container bash
```

### When Using Apptainer

Apptainer containers typically run in the foreground and provide a shell by default. If you need to run commands in an already running Apptainer container, you can use:

```bash
apptainer exec instance://gmxvg-instance bash
```

If you started the container as an instance:

```bash
apptainer instance start gromacs-gmxvg.sif gmxvg-instance
```

To exit the container terminal without stopping the container, simply type `exit` or press `Ctrl+D`.

### Gromacs Environment Variables

The docker-compose.yml file includes several environment variables that control Gromacs behavior. You can modify these values in the docker-compose.yml file before starting the container:

| Variable | Default | Description |
|----------|---------|-------------|
| GMX_MAXBACKUP | -1 | Maximum number of backup files (-1 = unlimited) |
| GMX_GPU_ID | (empty) | GPU ID to use (empty = all available) |
| GMX_NSTLIST | (empty) | Frequency of neighbor list updates (empty = auto) |
| GMX_USE_OPENCL | auto | Use OpenCL for GPU acceleration |
| GMX_DISABLE_CUDA_GPU_DETECTION | no | Disable CUDA GPU detection |
| GMX_OPENCL_VENDOR_LIBS | (empty) | OpenCL vendor libraries (empty = all available) |
| GMX_OPENCL_DEVICE_VENDOR | (empty) | OpenCL device vendor (empty = all available) |
| GMX_OPENCL_DEVICE_INDEX | (empty) | OpenCL device index (empty = all available) |
| GMX_OPENCL_DISABLE_COMPATIBILITY_CHECK | no | Disable OpenCL compatibility check |
| GMX_DISABLE_HARDWARE_DETECTION | no | Disable hardware detection |
| GMX_DISABLE_SIMD_KERNELS | no | Disable SIMD kernels |
| GMX_DISABLE_CUDA_TIMING | no | Disable CUDA timing |
| GMX_DISABLE_GPU_DETECTION | no | Disable GPU detection |
| GMX_DISABLE_GPU_TIMING | no | Disable GPU timing |

For more information on these environment variables, see the [Gromacs Docker Hub page](https://hub.docker.com/r/gromacs/gromacs).

## Using GMXvg

Once inside the container, you can use GMXvg to plot your GROMACS .xvg files:

```bash
# Check GMXvg version
gmxvg --version

# Get help
gmxvg -h

# Basic usage (will find and plot all .xvg files in the current directory)
gmxvg

# Specify output format
gmxvg --export_ext PNG

# Merge multiple plots
gmxvg --merge_patterns RMSD.xvg
```

For more information on using GMXvg, see the [GMXvg GitHub repository](https://github.com/TheBiomics/GMXvg).

## Using Gromacs

Gromacs commands are available in the container. For example:

```bash
# Check Gromacs version
gmx --version

# Run a Gromacs command
gmx grompp -f md.mdp -c input.gro -p topol.top -o output.tpr
```

For more information on using Gromacs, see the [Gromacs documentation](https://manual.gromacs.org/).
