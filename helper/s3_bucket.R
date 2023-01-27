connect_s3 <- function(...){
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
    return (aws_s3)
  } else { invisible(return (NULL))}
}
