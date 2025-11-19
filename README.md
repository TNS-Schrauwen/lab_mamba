Version 2.0.2
# Lab Mamba Docker Template

This is a flexible Docker template for building containerized lab tools using micromamba as the package manager. The template provides a solid foundation for scientific computing environments with conda-forge and bioconda package support.

## Template Structure

```
├── Dockerfile       # Main Docker configuration
├── conda.yml        # Conda environment specification
├── script.sh        # Custom scripts and tools
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

## Base Image

Built on `mambaorg/micromamba:1.5.10-noble` for reliability and performance.
