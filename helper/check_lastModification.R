# To compare main dataset last modification time
(function(..., KEY="dataset/dataset.RDS") {
  liara_s3 <- suppressWarnings(system("printenv LIARA_BUCKET_NAME", intern = T))
  if (length(liara_s3) != 0){
    aws_s3 <- paws::s3(
      config = list(
        credentials = list(
          creds = list(
            access_key_id = suppressWarnings(system("printenv LIARA_ACCESS_KEY", intern = T)),
            secret_access_key = suppressWarnings(system("printenv LIARA_SECRET_KEY", intern = T))
          )
        ),
        endpoint = paste0("https://",suppressWarnings(system("printenv LIARA_ENDPOINT", intern = T))),
        region = "default"
      )
    )
    aws_obj_list <- aws_s3$list_objects_v2(Bucket = system("printenv LIARA_BUCKET_NAME", intern = T))
    aws_obj_content <- lapply(aws_obj_list$Contents, function(x) x$Key==KEY) 
    dataset_num <- which(unlist(aws_obj_content)==TRUE)
    dataset_file <- aws_obj_list$Contents[[dataset_num]]
    dataset_lastMod <- dataset_file$LastModified
    lastModified_df <- aws_s3$get_object(Bucket = "aiworld", Key = "lastModifications/lastModified.rds")
    lastModified_rds <- "/tmp/lastModified.rds"
    writeBin(lastModified_df$Body,con=lastModified_rds)
    lastModified_fin <- readRDS(lastModified_rds)
    if (identical(lastModified_fin, dataset_lastMod)) return (TRUE) else return(FALSE)
  } else { return (NULL)}
})()
