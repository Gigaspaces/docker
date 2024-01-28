@Library('xap-common') _

pipeline {
    agent { 
        label 'gs-builder-large-ng' 
    }
    options {
        timestamps()
        durabilityHint("PERFORMANCE_OPTIMIZED")
    }
    environment {
        JAVA_VERSION = "Java8"
        XAP_NUM = xap.getXapVersion("${POM_VERSION}")
        XAP_NAME = 'gigaspaces-xap'
        GS_BUILD_NAME = "${XAP_NUM}-${BRANCH_NAME}-ci-${BUILD_NUMBER}"
        GS_ZIP_FILE = "${XAP_NAME}-${XAP_NUM}-${BRANCH_NAME}-${BUILD_NUMBER}.zip"
        GS_DISPLAY_NAME="${BRANCH_NAME}-${BUILD_NUMBER}"
        S3_BUCKET = 'xapbuild-ci'
        S3_REGION = 'us-east-1'
        S3_CREDS = 'xap-ops-automation'
        S3_PREFIX = "XAP/${XAP_NAME}/${BRANCH_NAME}"
    }
}