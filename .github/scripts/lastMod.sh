#!/bin/bash

DATA_STATUS=$(Rscript helper/check_lastModification.R)
echo "$DATA_STATUS"
if [ "$DATA_STATUS" = "[1] NULL" ]; then
    echo "No dataset detected"
elif [ "$DATA_STATUS" = "[1] FALSE" ]; then
    echo "Dataset has not been modified" 
    R CMD build .
    R CMD INSTALL primace_0.0.0.9000.tar.gz
    Rscript -e "primace::preprocessing()"
elif [ "$DATA_STATUS" = "[1] TRUE" ]; then
    echo "Dataset has been modified"
else 
    echo "Failed to access dataset"
fi

