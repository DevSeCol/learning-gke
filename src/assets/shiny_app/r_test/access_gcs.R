proj <- "anz_insto_training"
app_bucket <- "anz_training_app_bucket"

setwd("~/Documents/self/learning/cicd/test-xiaoxi/src/assets/shiny_app/r_test")

api_key_path <- "../app_data/key/anz-insto-training-ksa.json"


library(googleCloudStorageR)



gcs_auth(api_key_path)

gcs_get_bucket(app_bucket)

# bucket info
bucket_info <- gcs_get_bucket(app_bucket)
bucket_info

# files in bucket
objects <- gcs_list_objects(app_bucket)

objects$name

### download file###################################
f <- function(object){
  suppressWarnings(httr::content(object, encoding = "UTF-8"))
}

raw_download <- gcs_get_object(object_name = objects$name[1], 
                               bucket = app_bucket,
                               parseObject = T
                               # parseFunction = f
                               )




# save to local
gcs_get_object(object_name = objects$name[1], 
                               bucket = app_bucket,
               saveToDisk = "QAN_AXstock_ts1.csv")
qan_ax <- read.csv('QAN_AXstock_ts.csv',header = T)


### write ##########################################
# 1. Loading 
data("mtcars")
# 2. Print
head(mtcars)
 
f <- function(input, output) write.csv(input, row.names = FALSE, file = output)

gcs_upload(mtcars, 
           object_function = f,
           bucket = app_bucket,
           predefinedAcl = "bucketOwnerRead",
           type = "text/csv")
