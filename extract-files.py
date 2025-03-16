#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import extract_utils.tools

extract_utils.tools.DEFAULT_PATCHELF_VERSION = '0_9'

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)

from extract_utils.fixups_lib import (
    lib_fixup_vendorcompat,
    lib_fixups_user_type,
    libs_proto_3_9_1,
)

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/motorola/channel',
    'device/motorola/sdm632-common',
    "hardware/qcom-caf/msm8996",
    "hardware/qcom-caf/wlan",
    'vendor/motorola/sdm632-common',
    "vendor/qcom/opensource/dataservices",
]

lib_fixups: lib_fixups_user_type = {
    libs_proto_3_9_1: lib_fixup_vendorcompat,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/bin/charge_only_mode': blob_fixup()
        .add_needed('libmemset_shim.so'),
    'vendor/lib/hw/audio.primary.msm8953-moto.so': blob_fixup()
        .replace_needed('libtinyalsa.so', 'libtinyalsa-moto.so'),
    ('vendor/lib/sensors.ssc.so', 'vendor/lib64/sensors.ssc.so'): blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so'),
    'vendor/lib/soundfx/libmmieffectswrapper.so': blob_fixup()
        .replace_needed('libtinyalsa.so', 'libtinyalsa-moto.so'),
    'vendor/lib/soundfx/libspeakerbundle.so': blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so')
        .replace_needed('libtinyalsa.so', 'libtinyalsa-moto.so'),
    'vendor/lib/libmot_gpu_mapper.so': blob_fixup()
        .add_needed('libgui_shim_vendor.so'),
    'vendor/lib/libmmcamera2_pproc_modules.so': blob_fixup()
        .binary_regex_replace(b'\x70\x72\x6F\x64\x75\x63\x74\x2E\x6D\x61\x6E\x75', b'\x70\x72\x6F\x64\x75\x63\x74\x2E\x6E\x6F\x70\x65'),
}  # fmt: skip

module = ExtractUtilsModule(
    'channel',
    'motorola',
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(module, 'sdm632-common', module.vendor)
    utils.run()
