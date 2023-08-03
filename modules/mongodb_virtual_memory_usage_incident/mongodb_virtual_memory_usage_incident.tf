resource "shoreline_notebook" "mongodb_virtual_memory_usage_incident" {
  name       = "mongodb_virtual_memory_usage_incident"
  data       = file("${path.module}/data/mongodb_virtual_memory_usage_incident.json")
  depends_on = [shoreline_action.invoke_increase_swap,shoreline_action.invoke_mongo_optimize,shoreline_action.invoke_remove_mongo_collection]
}

resource "shoreline_file" "increase_swap" {
  name             = "increase_swap"
  input_file       = "${path.module}/data/increase_swap.sh"
  md5              = filemd5("${path.module}/data/increase_swap.sh")
  description      = "Increase the swap space to allow MongoDB to use more virtual memory."
  destination_path = "/agent/scripts/increase_swap.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "mongo_optimize" {
  name             = "mongo_optimize"
  input_file       = "${path.module}/data/mongo_optimize.sh"
  md5              = filemd5("${path.module}/data/mongo_optimize.sh")
  description      = "Optimize the MongoDB queries to reduce the memory usage."
  destination_path = "/agent/scripts/mongo_optimize.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "remove_mongo_collection" {
  name             = "remove_mongo_collection"
  input_file       = "${path.module}/data/remove_mongo_collection.sh"
  md5              = filemd5("${path.module}/data/remove_mongo_collection.sh")
  description      = "Remove unused indexes or collections to free up memory space."
  destination_path = "/agent/scripts/remove_mongo_collection.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_increase_swap" {
  name        = "invoke_increase_swap"
  description = "Increase the swap space to allow MongoDB to use more virtual memory."
  command     = "`chmod +x /agent/scripts/increase_swap.sh && /agent/scripts/increase_swap.sh`"
  params      = ["SWAP_FILE_PATH","SWAP_SIZE"]
  file_deps   = ["increase_swap"]
  enabled     = true
  depends_on  = [shoreline_file.increase_swap]
}

resource "shoreline_action" "invoke_mongo_optimize" {
  name        = "invoke_mongo_optimize"
  description = "Optimize the MongoDB queries to reduce the memory usage."
  command     = "`chmod +x /agent/scripts/mongo_optimize.sh && /agent/scripts/mongo_optimize.sh`"
  params      = ["COLLECTION_NAME","DATABASE_NAME"]
  file_deps   = ["mongo_optimize"]
  enabled     = true
  depends_on  = [shoreline_file.mongo_optimize]
}

resource "shoreline_action" "invoke_remove_mongo_collection" {
  name        = "invoke_remove_mongo_collection"
  description = "Remove unused indexes or collections to free up memory space."
  command     = "`chmod +x /agent/scripts/remove_mongo_collection.sh && /agent/scripts/remove_mongo_collection.sh`"
  params      = ["COLLECTION_NAME","DATABASE_NAME"]
  file_deps   = ["remove_mongo_collection"]
  enabled     = true
  depends_on  = [shoreline_file.remove_mongo_collection]
}

