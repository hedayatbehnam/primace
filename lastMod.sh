#!/bin/bash
DATA_STATUS=$(Rscript "helper/check_lastModification.R")

if [[ "$DATA_STATUS" == "NULL" ]]; then
    echo "No dataset detected"
elif [[ "$DATA_STATUS" == "FALSE" ]]; then
    echo "Dataset has not been modified" 
    Rscript -e "primace::preprocessing()"
elif [[ "$DATA_STATUS" == "TRUE" ]]; then
    echo "Dataset has been modified"
fi

