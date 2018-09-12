#!/usr/bin/env bash

set -e

readonly TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"

readonly CI_DIR="$( cd $(dirname $0) ; pwd -P )"
readonly ROOT_DIR="$( cd ${CI_DIR}/.. ; pwd -P )"

cd ${CI_DIR}
git clone git@iis-git.ee.ethz.ch:pulp-sw/pulp_pipeline.git -b master sdk > /dev/null
readonly SDK_DIR="${CI_DIR}/sdk"

cd ${ROOT_DIR}
./update-ips.py

readonly BOARDS=(zc706 juno)

# TODO: Build for all boards in $BOARDS; e.g.,
# for b in "${BOARDS[@]}"; do
#   export BOARD="$b"
#   Clone entire working directory and perform parallel build inside that directory?  Or would it be
#   better to one Jenkins job per target board (with a parameter passed to this script) to separate
#   log and bitstream at the Jenkins level?
# done

export BOARD="zc706"

cd ${ROOT_DIR}/fpga

source sourceme.iis.sh
unset SDK_WORKSPACE

vivado-2016.1 make ips
vivado-2016.1 make synth-ulpcluster-nogui
vivado-2016.1 make synth-ulpsoc-nogui

if [[ "$BOARD" == "juno" ]]; then
    cd bigpulp
else
    cd bigpulp-z-70xx
fi

vivado-2015.1 make all

readonly BIGPULP_BASEFILENAME="bigpulp-${BOARD}"
readonly BITSTREAM_FILENAME="${BIGPULP_BASEFILENAME}.bit"
mv bigpulp*.bit "${BITSTREAM_FILENAME}"

if [[ "$BOARD" != "juno" ]]; then
    readonly HWDEF_FILENAME="${BIGPULP_BASEFILENAME}.hwdef"
    mv bigpulp*.hwdef "${HWDEF_FILENAME}"
else
    unset HWDEF_FILENAME
fi

function push_artefact() {
    local -r short_hash="$(git rev-parse --short=12 HEAD)"
    local -r version="${TIMESTAMP}_${short_hash}"

    ${SDK_DIR}/bin/artefact-push \
        --file "${BITSTREAM_FILENAME}" \
        ${HWDEF_FILENAME:+--file "$HWDEF_FILENAME"} \
        --artefact "bigpulp-bitstream" \
        --branch "${gitlabBranch}" \
        --version "${version}" \
        --build "${BOARD}" \
        --no-distrib
}

push_artefact
