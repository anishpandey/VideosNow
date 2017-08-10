#!/bin/bash



set -e

echo "COPY VOC SDK"

VOCSDK_FRAMEWORK_NAME="VocSdk.framework"


if [ -z ${1+x} ]; then
	echo  "location of the unpacked SDK distribution archive must be first parameter"
	exit 1
fi

VOCSDK_DIST_DIR="${1}"

VOCSDK_DEST="${2}"

if [ -z ${2+x} ]; then

	if [ -z ${PROJECT_DIR+x} ]; then
		echo  "PROJECT_DIR is not set, don't know where to copy the sdk"
		exit 1
	fi

	VOCSDK_DEST="${PROJECT_DIR}"
fi

if [ -z ${PLATFORM_NAME+x} ]; then
	echo  "PLATFORM_NAME is not set"
	exit 1
fi


set -u


VOCSDK_FRAMEWORK_SRC="${BUILT_PRODUCTS_DIR}/${VOCSDK_FRAMEWORK_NAME}"

if [[ ! -e "${VOCSDK_FRAMEWORK_SRC}" ]] ; then

	if [[ ! -d "${VOCSDK_DIST_DIR}" ]] ; then
		echo  "${VOCSDK_DIST_DIR} does not exist or is a file"
		exit 1
	fi

	VOCSDK_FRAMEWORK_SRC="${VOCSDK_DIST_DIR}/${PLATFORM_NAME}/${VOCSDK_FRAMEWORK_NAME}"

fi


if [[ ! -d "${VOCSDK_FRAMEWORK_SRC}" ]]; then
	echo  "${VOCSDK_FRAMEWORK_SRC} does not exist or is a file."
	exit 1
fi

echo "Copy ${VOCSDK_FRAMEWORK_SRC} => ${VOCSDK_DEST}"

rm -fr "${VOCSDK_DEST}/${VOCSDK_FRAMEWORK_NAME}"
cp -R "${VOCSDK_FRAMEWORK_SRC}" "${VOCSDK_DEST}"
