#!/bin/bash

DATA_STATUS=$(Rscript helper/check_lastModification.R)
echo "$DATA_STATUS"
if [ "$DATA_STATUS" == NULL ]; then
    echo "No dataset detected"
elif [ "$DATA_STATUS" == FALSE ]; then
    echo "Dataset has not been modified" 
else
    echo "Dataset has been modified"
fi

