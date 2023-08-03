

#!/bin/bash



# Define the MongoDB database and collection to remove

database_name=${DATABASE_NAME}

collection_name=${COLLECTION_NAME}



# Connect to the MongoDB instance and remove the collection

mongo $database_name --eval "db.$collection_name.drop()"



# Print a message to confirm the collection was removed

echo "The $collection_name collection has been removed from the $database_name database."