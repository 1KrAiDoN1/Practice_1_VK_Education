#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p jars
base=https://repo.maven.apache.org/maven2/org/apache/iceberg
curl --fail --location --retry 3 -o jars/iceberg-spark-runtime-3.5_2.12-1.7.1.jar \
  "$base/iceberg-spark-runtime-3.5_2.12/1.7.1/iceberg-spark-runtime-3.5_2.12-1.7.1.jar"
curl --fail --location --retry 3 -o jars/iceberg-aws-bundle-1.7.1.jar \
  "$base/iceberg-aws-bundle/1.7.1/iceberg-aws-bundle-1.7.1.jar"
printf '%s\n' 'Два файла Iceberg сохранены в jars/.'
