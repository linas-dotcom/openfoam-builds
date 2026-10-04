#!/bin/bash
# Installs prebuilt SU2 v8.5.0 (MPI, release) into ~/SU2.   usage: bash install_su2.sh; source ~/cfd/su2.sh
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
export DEBIAN_FRONTEND=noninteractive
apt-get install -y -qq --no-install-recommends openmpi-bin libopenmpi-dev > /dev/null || true
tar xzf "$HERE/su2/SU2-8.5.0-ubuntu24.04-mpi.tar.gz" -C ~
mkdir -p ~/cfd
cat > ~/cfd/su2.sh <<'EOS'
export SU2_RUN=~/SU2/bin SU2_HOME=~/SU2
export PATH=$SU2_RUN:$PATH PYTHONPATH=$SU2_RUN:$PYTHONPATH
# OpenMPI 4.1 in this container: one-sided comms need osc=pt2pt, otherwise MPI_Win_create fails
export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 OMPI_MCA_btl_vader_single_copy_mechanism=none OMPI_MCA_osc=pt2pt
EOS
source ~/cfd/su2.sh && command -v SU2_CFD && echo "SU2 ready: source ~/cfd/su2.sh"
