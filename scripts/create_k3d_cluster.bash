#!/usr/bin/env bash

set -euxo pipefail

k3d cluster create --agents 1 \
    --k3s-node-label riju.radian.codes/role=server@server:0 \
    --k3s-node-label riju.radian.codes/role=worker@agent:0
