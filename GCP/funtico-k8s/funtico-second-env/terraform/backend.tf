terraform {

  backend "gcs" {
    bucket      = "funtico-production-tf"
    prefix      = "env/production"
    credentials = "./json/tf_service_account.json"
  }

}
