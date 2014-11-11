#!/bin/bash
# Copyright (C) 2014 The NamelessRom Project
# Copyright (C) 2014 Kilian von Pflugk
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

###########################################
# Delete device/* when everything is done #
###########################################

DEVICE=$1

# Find CM.mk file for device
r2d2=$(ls device/*/${DEVICE}/cm.mk)

# Find the folder where the cm.mk is stored
c3po=$(dirname ${r2d2})

# Search for cm's nfc_enhanced.mk and replace it
for i in device/*/*/*.mk
do
 sed -i 's/vendor\/cm\/config\/nfc_enhanced.mk/vendor\/nameless\/config\/nfc_enhanced.mk/' $i
done

# Remove all CM Vendor config from cm.mk and save it to nameless_device.mk
sed '/vendor\/cm\/config/d' ${r2d2} >  ${c3po}/nameless_${DEVICE}.mk

# Add nameless config
echo 'include vendor/nameless/config/common.mk' >> ${c3po}/nameless_${DEVICE}.mk

# Add nameless apns
echo '$(call inherit-product, vendor/nameless/config/apns.mk)' >> ${c3po}/nameless_${DEVICE}.mk

# Add nameless Product name
echo "PRODUCT_NAME := nameless_${DEVICE}" >> ${c3po}/nameless_${DEVICE}.mk

add_lunch_combo ${DEVICE}-userdebug
