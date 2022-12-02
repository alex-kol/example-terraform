terraform {
    
 backend "gcs" {
  bucket  = "funtico-prod-tf"
  prefix  = "env/prod"
  credentials = "./json/tf_service_account.json"
 }
 
}
