# openfoam-builds

Prebuilt OpenFOAM for Claude cloud workspaces (Ubuntu 24.04, x86_64), so a new session does not
need to compile for 3–4 hours.

| Build | Folder |
|---|---|
| OpenFOAM-14 (openfoam.org), commit 162fa7a2, 2026-09-30 | `openfoam-14/` (archive split into <100 MB parts) |
| OpenFOAM v2606 (openfoam.com) | to be added |

Build options: Gcc 13, double precision, 32-bit labels, `-O3`, system OpenMPI 4.1, system Scotch 7 and METIS,
Zoltan from ThirdParty-14.

## Install in a new session

```bash
git clone https://github.com/linas-dotcom/openfoam-builds
bash openfoam-builds/install_openfoam14.sh
source ~/cfd/of14.sh
```

## Licence

OpenFOAM is free software under the GNU GPL v3. These are unmodified builds of the upstream sources:
<https://github.com/OpenFOAM/OpenFOAM-14> and <https://github.com/OpenFOAM/ThirdParty-14>.
The build-only preference file used is `OpenFOAM-14/etc/prefs.sh` (included in the archive).
