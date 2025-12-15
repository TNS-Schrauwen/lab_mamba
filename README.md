Version 2.0.2
# Lab Mamba Docker Template

This is a flexible Docker template for building containerized lab tools using micromamba as the package manager. The template provides a solid foundation for scientific computing environments with conda-forge and bioconda package support, now with automated CI/CD using Drone and multi-architecture support.

## Repository Structure

```
├── Dockerfile       # Main Docker configuration
├── conda.yml        # Conda environment specification
├── script.sh        # Custom scripts and tools
├── .drone.yml       # Drone CI/CD configuration
├── ci/              # CI/CD testing infrastructure
│   ├── smoke.nf     # Nextflow smoke test workflow
│   └── nextflow.config  # Nextflow configuration
└── README.md        # This file
```

## Quick Start

1. **Add your dependencies** to `conda.yml`:
   ```yaml
   channels:
   - conda-forge
   - bioconda
   dependencies:
   - python=3.11
   - numpy
   - pandas
   - your-package-here
   ```

2. **Add custom scripts** to `script.sh` or create new script files

3. **Update the Dockerfile** copy commands if you have additional files:
   ```dockerfile
   COPY your-script.py /home/mambauser/your-script.py
   ```

4. **Build your image**:
   ```bash
   docker build -t your-lab-tool .
   ```

## Customization Guide

### Adding Conda Dependencies
Edit `conda.yml` to include packages from conda-forge or bioconda:
```yaml
dependencies:
- conda-forge::scipy
- bioconda::bwa
- conda-forge::jupyter
```

### Adding Custom Scripts
- Modify `script.sh` for simple bash scripts
- Add new script files and update the Dockerfile COPY commands
- Scripts are automatically made executable and added to PATH

### Adding Files and Programs
Update the Dockerfile to copy additional files:
```dockerfile
COPY my-program.py /home/mambauser/my-program.py
COPY config/ /home/mambauser/config/
```

## Features

- **Micromamba**: Fast, lightweight conda package manager
- **Multi-channel support**: conda-forge and bioconda pre-configured
- **Cache optimization**: Pip, R, and Python caches configured for /tmp
- **Script wrapper**: Automatic PATH setup for custom scripts
- **Lock file generation**: Reproducible environment snapshots
- **Automated CI/CD**: Drone pipelines for building, testing, and publishing
- **Multi-architecture support**: Builds for both AMD64 and ARM64 platforms
- **Automated testing**: Nextflow-based smoke tests before deployment

## Usage

The built container provides:
- All conda dependencies installed in base environment
- Custom scripts available system-wide
- Optimized caching for development workflows
- Non-root user setup for security

Run your container:
```bash
docker run -it your-lab-tool
```

## CI/CD with Drone

This repository uses Drone CI/CD for automated building, testing, and publishing of Docker images. The pipeline supports multi-architecture builds (AMD64 and ARM64) and includes automated testing before deployment.

### Pipeline Structure

The `.drone.yml` file defines two parallel pipelines:

1. **build-amd64**: Builds and tests for x86_64 architecture
2. **build-arm64**: Builds and tests for ARM64 architecture

### Pipeline Steps

Each pipeline performs the following steps:

1. **Build Test Image**: Creates a local Docker image with commit SHA tag
2. **Nextflow Smoke Test**: Runs automated tests using Nextflow
3. **Publish**: Pushes images to AWS ECR based on branch/tag

### Testing Strategy

The repository demonstrates two testing approaches:

#### AMD64 Testing
- Uses the `script` command (custom script from script.sh)
- Tests the functionality of custom scripts included in the image
- Command: `--command script`

#### ARM64 Testing
- Uses a direct command test (`wget -qO- https://example.com`)
- Tests network connectivity and basic command execution
- Command: `--command "wget -qO- https://example.com"`

### Nextflow Smoke Tests

The smoke tests are implemented using Nextflow (`ci/smoke.nf`):
- Takes a container image and command as parameters
- Executes the command inside the container
- Captures output to `smoke_output.txt`
- Results are published to `results/smoke/` directory

Configuration (`ci/nextflow.config`):
- Docker enabled with user permissions
- Local executor with single process
- Work directory set to `/tmp/nextflow-work`

### Publishing Strategy

**Branch Pushes (non-main)**:
- Tags: `${DRONE_BRANCH}-linux-amd64` or `${DRONE_BRANCH}-linux-arm64`
- Branch names with slashes are converted (e.g., `feature/test` → `feature-test`)

**Main Branch**:
- AMD64: `main-linux-amd64`, `latest-linux-amd64`, `latest`
- ARM64: `main-linux-arm64`, `latest-linux-arm64`

**Tagged Releases**:
- Tags: `${DRONE_TAG}-linux-amd64` or `${DRONE_TAG}-linux-arm64`

### Environment Variables

The pipeline uses the following secrets (configured in Drone):
- `aws_access_key_id`: AWS access key for ECR
- `aws_secret_access_key`: AWS secret key for ECR
- `repo_name`: ECR repository name
- `ecr_registry`: ECR registry URL

### Running Tests Locally

You can run the smoke tests locally:

```bash
# Build the image
docker build -t lab-mamba-test:local .

# Run Nextflow smoke test
nextflow run ci/smoke.nf \
  -c ci/nextflow.config \
  --container lab-mamba-test:local \
  --command script
```

## Base Image

Built on `mambaorg/micromamba:1.5.10-noble` for reliability and performance.
