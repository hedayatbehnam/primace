#!/bin/bash

DATA_STATUS=$(Rscript helper/check_lastModification.R)
echo "$DATA_STATUS"
if [ "$DATA_STATUS" = "[1] NULL" ]; then
    echo "No dataset detected"
elif [ "$DATA_STATUS" = "[1] FALSE" ]; then
    echo "Dataset has not been modified" 
    Rscript -e "devtools::load_all('.')"
    Rscript -e "devtools::build()"
    Rscript -e "install.packages('primace_0.0.0.9000.tar.gz', repos=NULL, type='source')"
    Rscript -e "library(primace)"
    Rscript -e "primace::preprocessing()"
elif [ "$DATA_STATUS" = "[1] TRUE" ]; then
    echo "Dataset has been modified"
else 
    echo "Failed to access dataset"
fi

