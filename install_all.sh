#!/bin/bash
# OpenFOAM-14 + SU2 + Python CFD tools (Cantera, gmsh, foamlib, PyVista)
HERE=$(cd "$(dirname "$0")" && pwd)
bash "$HERE/install_openfoam14.sh" && bash "$HERE/install_openfoamv2606.sh" && bash "$HERE/install_su2.sh" && bash "$HERE/install_python_tools.sh"
