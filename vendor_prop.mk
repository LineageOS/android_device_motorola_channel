#
# vendor props for channel
#

# Sensors
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.sensors=channel \
    ro.vendor.sensors.amd=false \
    ro.vendor.sensors.facing=false \
    ro.vendor.sensors.glance_approach=false \
    ro.vendor.sensors.glance_cover_to_wake=false \
    ro.vendor.sensors.mot_detect=true \
    ro.vendor.sensors.mot_ltv=true \
    ro.vendor.sensors.pedometer=false \
    ro.vendor.sensors.pmd=false \
    ro.vendor.sensors.rmd=false \
    ro.vendor.sensors.scrn_ortn=false \
    ro.vendor.sensors.sta_detect=true \
    ro.vendor.sdk.sensors.gestures=false

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.camera.expose.aux=1

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=320
