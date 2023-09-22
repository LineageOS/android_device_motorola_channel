#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        # libutils-v32
        vendor/lib/sensors.ssc.so | vendor/lib64/sensors.ssc.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed libutils.so libutils-v32.so "${2}"
            ;;
        # libspeakerbundle
        vendor/lib/soundfx/libspeakerbundle.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed libutils.so libutils-v32.so "${2}"
            "${PATCHELF}" --replace-needed libtinyalsa.so libtinyalsa-moto.so "${2}"
            ;;
        # Fix missing symbols
        vendor/lib/libmot_gpu_mapper.so)
            [ "$2" = "" ] && return 0
            for LIBGUI_SHIM in $(grep -L "libgui_shim_vendor.so" "${2}"); do
                "${PATCHELF}" --add-needed "libgui_shim_vendor.so" "${LIBGUI_SHIM}"
            done
            ;;
        # Fix camera recording
        vendor/lib/libmmcamera2_pproc_modules.so)
            [ "$2" = "" ] && return 0
            sed -i "s/ro.product.manufacturer/ro.product.nopefacturer/" "${2}"
            ;;
        # memset shim
        vendor/bin/charge_only_mode)
            [ "$2" = "" ] && return 0
            for  LIBMEMSET_SHIM in $(grep -L "libmemset_shim.so" "${2}"); do
                "${PATCHELF}" --add-needed "libmemset_shim.so" "$LIBMEMSET_SHIM"
            done
            ;;
        # rename moto modified tinyalsa
        vendor/lib/libtinyalsa-moto.so | vendor/lib64/libtinyalsa-moto.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --set-soname libtinyalsa-moto.so "${2}"
            ;;
        # rename moto modified tinyalsa
        vendor/lib/soundfx/libmmieffectswrapper.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed libtinyalsa.so libtinyalsa-moto.so "${2}"
            ;;
        # rename moto modified primary audio to not conflict with source built
        vendor/lib/hw/audio.primary.msm8953-moto.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --set-soname audio.primary.msm8953-moto.so "${2}"
            "${PATCHELF}" --replace-needed libtinyalsa.so libtinyalsa-moto.so "${2}"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=channel
export DEVICE_COMMON=sdm632-common
export VENDOR=motorola
export VENDOR_COMMON=${VENDOR}

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/extract-files.sh" "$@"
