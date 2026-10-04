#!/bin/bash
# Installs the prebuilt OpenFOAM-14 (Foundation) into ~/OpenFOAM in a fresh Ubuntu 24.04 cloud workspace.
# usage: bash install_openfoam14.sh        then: source ~/cfd/of14.sh
set -e
ASSET=OpenFOAM-14-ubuntu24.04-linux64GccDPInt32Opt.tar.gz

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq || true
apt-get install -y -qq --no-install-recommends openmpi-bin libopenmpi-dev libscotch-dev libptscotch-dev \
    libmetis-dev libreadline-dev zlib1g-dev flex libfl-dev > /dev/null

HERE=$(cd "$(dirname "$0")" && pwd)
mkdir -p ~/OpenFOAM && cd ~/OpenFOAM
cat "$HERE"/openfoam-14/$ASSET.part* > $ASSET
(cd "$HERE/openfoam-14" && sed "s#  #  $HOME/OpenFOAM/#" SHA256SUMS | sha256sum -c -)
tar xzf $ASSET && rm -f $ASSET

mkdir -p ~/cfd
cat > ~/cfd/of14.sh <<'EOF'
source ~/OpenFOAM/OpenFOAM-14/etc/bashrc
export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 OMPI_MCA_btl_vader_single_copy_mechanism=none
EOF
source ~/cfd/of14.sh
foamRun -help > /dev/null && echo "OpenFOAM-14 ready: source ~/cfd/of14.sh"
