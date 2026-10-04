#!/bin/bash
# Cantera (combustion thermochemistry), gmsh, foamlib, PyVista/meshio + libs for offscreen rendering, and tools/cj.py
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
export DEBIAN_FRONTEND=noninteractive
apt-get install -y -qq --no-install-recommends libglu1-mesa libxcursor1 libxinerama1 libxft2 libxrender1 libgl1 xvfb > /dev/null || true
pip install --break-system-packages -q cantera gmsh foamlib pyvista meshio
mkdir -p ~/cfd/tools && cp "$HERE"/tools/*.py ~/cfd/tools/
python3 -c "import cantera, gmsh, foamlib, pyvista; print('cantera', cantera.__version__, '| gmsh', gmsh.__version__)"
echo "CJ detonation / flame states: python3 ~/cfd/tools/cj.py kerosene 1.0"
