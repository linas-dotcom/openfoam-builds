# openfoam-builds

Prebuilt OpenFOAM for Claude cloud workspaces (Ubuntu 24.04, x86_64), so a new session does not
need to compile for 3–4 hours.

| Build | Folder |
|---|---|
| OpenFOAM-14 (openfoam.org), commit 162fa7a2, 2026-09-30 | `openfoam-14/` (archive split into <100 MB parts) |
| SU2 v8.5.0 (MPI, release, no Python wrapper) | `su2/` |
| Python tools: Cantera, gmsh, foamlib, PyVista, `tools/cj.py` (CJ detonation / flame states) | installed from PyPI |
| OpenFOAM v2606 (openfoam.com, ESI), api 2606 patch 0 | `openfoam-v2606/` (split archive) |

Build options: Gcc 13, double precision, 32-bit labels, `-O3`, system OpenMPI 4.1, system Scotch 7 and METIS,
Zoltan from ThirdParty-14.

## Install in a new session

```bash
git clone https://github.com/linas-dotcom/openfoam-builds
bash openfoam-builds/install_all.sh        # or install_openfoam14.sh / install_su2.sh / install_python_tools.sh
source ~/cfd/of14.sh                        # OpenFOAM-14
source ~/cfd/v2606.sh                       # OpenFOAM v2606 (bash openfoam-builds/install_openfoamv2606.sh)
source ~/cfd/su2.sh                         # SU2
```

SU2 note: OpenMPI 4.1 in these containers needs `OMPI_MCA_osc=pt2pt` (set by `su2.sh`), otherwise `MPI_Win_create` fails.

Use one OpenFOAM per shell: source either `of14.sh` or `v2606.sh`, not both. A mesh written by OpenFOAM-14 (new zone format) cannot be read by v2606; regenerate it with v2606 tools.
v2606 build: system Scotch 7 and METIS (etc/config.sh/scotch, metis edited), no KaHIP, no ParaView; source from dl.openfoam.com.

## Licence

SU2 is LGPL 2.1 (<https://github.com/su2code/SU2>, tag v8.5.0); Eigen was fetched from the GitHub mirror eigen-mirror/eigen.


OpenFOAM is free software under the GNU GPL v3. These are unmodified builds of the upstream sources:
<https://github.com/OpenFOAM/OpenFOAM-14> and <https://github.com/OpenFOAM/ThirdParty-14>.
The build-only preference file used is `OpenFOAM-14/etc/prefs.sh` (included in the archive).
