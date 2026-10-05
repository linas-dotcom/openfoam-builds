#!/bin/bash
# Installs the prebuilt OpenFOAM v2606 (ESI, openfoam.com) into ~/OpenFOAM in a fresh Ubuntu 24.04 cloud workspace.
# usage: bash install_openfoamv2606.sh        then: source ~/cfd/v2606.sh
set -e
ASSET=OpenFOAM-v2606-ubuntu24.04-linux64GccDPInt32Opt.tar.gz

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq || true
apt-get install -y -qq --no-install-recommends openmpi-bin libopenmpi-dev libscotch-dev libptscotch-dev \
    libmetis-dev libreadline-dev zlib1g-dev flex libfl-dev > /dev/null

HERE=$(cd "$(dirname "$0")" && pwd)
mkdir -p ~/OpenFOAM && cd ~/OpenFOAM
cat "$HERE"/openfoam-v2606/$ASSET.part* > $ASSET
(cd "$HERE/openfoam-v2606" && sed "s#  #  $HOME/OpenFOAM/#" SHA256SUMS | sha256sum -c -)
tar xzf $ASSET && rm -f $ASSET

mkdir -p ~/cfd
cat > ~/cfd/v2606.sh <<'EOF'
source ~/OpenFOAM/OpenFOAM-v2606/etc/bashrc
export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 OMPI_MCA_btl_vader_single_copy_mechanism=none
EOF
set +e; source ~/cfd/v2606.sh 2>/dev/null
simpleFoam -help > /dev/null && echo "OpenFOAM v2606 ready: source ~/cfd/v2606.sh"
