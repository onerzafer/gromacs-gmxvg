# Gromacs with GMXvg Docker Image

This Docker image is based on the official [Gromacs Docker image](https://hub.docker.com/r/gromacs/gromacs) and includes [GMXvg](https://github.com/TheBiomics/GMXvg), a tool to plot GROMACS .xvg files.

## Building the Docker Image

To build the Docker image, run the following command from the directory containing the Dockerfile:

```bash
docker build -t gromacs-gmxvg .
```

## Running the Docker Container

### Using Docker Run

To run the Docker container directly, use the following command:

```bash
docker run -it --rm -v $(pwd):/data gromacs-gmxvg
```

This will:
- Start an interactive container (`-it`)
- Remove the container when it exits (`--rm`)
- Mount the current directory to `/data` in the container (`-v $(pwd):/data`)
- Use the `gromacs-gmxvg` image

### Using Docker Compose

Alternatively, you can use Docker Compose to run the container:

1. Make sure you have Docker Compose installed
2. Create a directory for your data:
   ```bash
   mkdir -p data
   ```
3. Start the container using Docker Compose:
   ```bash
   docker-compose up -d
   ```

This will:
- Build the Docker image if it doesn't exist
- Start the container in detached mode (`-d`)
- Mount the `./data` directory to `/data` in the container
- Set up Gromacs environment variables (see below)

To stop the container:
```bash
docker-compose down
```

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
