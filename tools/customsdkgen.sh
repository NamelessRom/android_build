#!/bin/bash

SDK_VER=19
CUSTOM_VER=319
CUSTOM_NAME=nameless

if [ -z "$OUT" ]; then
    echo "Please lunch a product before using this command"
    exit 1
else
    OUTDIR=${OUT%/*/*/*}
fi

STUBJAR=${OUTDIR}/target/common/obj/JAVA_LIBRARIES/android_stubs_current_intermediates/classes.jar
FRAMEWORKJAR=${OUTDIR}/target/common/obj/JAVA_LIBRARIES/framework_intermediates/classes.jar
COREJAR=${OUTDIR}/target/common/obj/JAVA_LIBRARIES/core_intermediates/classes.jar
FRAMEWORKRESJAR=${OUTDIR}/target/common/obj/JAVA_LIBRARIES/framework-base_intermediates/classes.jar
TELEPHONYJAR=${OUTDIR}/target/common/obj/JAVA_LIBRARIES/telephony-common_intermediates/classes.jar
OKHTTPJAR=${OUTDIR}/target/common/obj/JAVA_LIBRARIES/okhttp_intermediates/classes.jar
ACRAJAR=${OUTDIR}/target/common/obj/JAVA_LIBRARIES/acra_intermediates/classes.jar

if [ ! -f $STUBJAR ]; then
make $STUBJAR
fi
if [ ! -f $FRAMEWORKJAR ]; then
make $FRAMEWORKJAR
fi
if [ ! -f $COREJAR ]; then
make $COREJAR
fi
if [ ! -f $FRAMEWORKRESJAR ]; then
make $FRAMEWORKRESJAR
fi
if [ ! -f $TELEPHONYJAR ]; then
make $TELEPHONYJAR
fi
if [ ! -f $OKHTTPJAR ]; then
make $OKHTTPJAR
fi
if [ ! -f $ACRAJAR ]; then
make $ACRAJAR
fi

TMP_DIR=${OUTDIR}/tmp
mkdir -p ${TMP_DIR}
$(cd ${TMP_DIR}; jar -xf ${STUBJAR})
$(cd ${TMP_DIR}; jar -xf ${COREJAR})
$(cd ${TMP_DIR}; jar -xf ${FRAMEWORKJAR})
$(cd ${TMP_DIR}; jar -xf ${FRAMEWORKRESJAR})
$(cd ${TMP_DIR}; jar -xf ${TELEPHONYJAR})
$(cd ${TMP_DIR}; jar -xf ${OKHTTPJAR})
$(cd ${TMP_DIR}; jar -xf ${ACRAJAR})

jar -cf ${OUTDIR}/android.jar -C ${TMP_DIR}/ .

echo "android.jar created at ${OUTDIR}/android.jar"
echo "Now attempting to create new sdk platform with it"

if [ -z "$ANDROID_HOME" ]; then
    ANDROID=$(command -v android)
    ANDROID_HOME=${ANDROID%/*}
    if [ -z "$ANDROID_HOME" ]; then
        echo "ANDROID_HOME variable is not set. Do you have the sdk installed ?"
        exit 1
    fi
fi

cp -rf ${ANDROID_HOME}/platforms/android-${SDK_VER} ${ANDROID_HOME}/platforms/android-${SDK_VER}-${CUSTOM_NAME}
rm -f ${ANDROID_HOME}/platforms/android-${SDK_VER}-${CUSTOM_NAME}/android.jar
cp -f ${OUTDIR}/android.jar ${ANDROID_HOME}/platforms/android-${SDK_VER}-${CUSTOM_NAME}/android.jar
sed -i 's/^ro\.build\.version\.sdk=.*/ro.build.version.sdk=319/g' ${ANDROID_HOME}/platforms/android-${SDK_VER}-${CUSTOM_NAME}/build.prop
sed -i 's/^ro\.build\.version\.release=.*/ro.build.version.release=4.4-nameless/g' ${ANDROID_HOME}/platforms/android-${SDK_VER}-${CUSTOM_NAME}/build.prop
sed -i 's/AndroidVersion.ApiLevel=19/AndroidVersion.ApiLevel=319/' ${ANDROID_HOME}/platforms/android-${SDK_VER}-${CUSTOM_NAME}/source.properties
sed -i 's/Pkg.Desc=/Pkg.Desc=NamelessROM /' ${ANDROID_HOME}/platforms/android-${SDK_VER}-${CUSTOM_NAME}/source.properties
echo "New SDK created. To build using $CUSTOM_NAME sdk select sdk version $CUSTOM_VER in Studio/ADT"
