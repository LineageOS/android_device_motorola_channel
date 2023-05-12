# Inherit some common Lineage stuff.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Device
$(call inherit-product, $(LOCAL_PATH)/device.mk)

BUILD_FINGERPRINT := "motorola/channel_retail/channel:10/QPYS30.85-23-8-2/c00f57:user/release-keys"
PRODUCT_BRAND := motorola
PRODUCT_DEVICE := channel
PRODUCT_MANUFACTURER := motorola
PRODUCT_MODEL := moto g(7) play
PRODUCT_NAME := lineage_channel

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=channel \
    PRIVATE_BUILD_DESC="channel_retail-user 10 QPYS30.85-23-8-2 c00f57 release-keys"
