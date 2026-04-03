#!/bin/bash

DATASET="hymenoptera_odb12"
DATA_DIR=calferv_proj/GWAS_2026/assemblies/busco/datasets

# download busco dataset for offline running of busco on cluster
micromamba run -n busco busco --download_path ${DATA_DIR} --download ${DATASET}