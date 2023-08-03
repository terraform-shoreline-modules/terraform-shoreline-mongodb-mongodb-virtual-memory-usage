
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB virtual memory usage incident.
---

This incident type refers to an issue with high virtual memory usage in a MongoDB instance. It can lead to performance degradation or even service downtime. It requires immediate attention from the responsible team to investigate the root cause and take corrective measures to resolve the issue.

### Parameters
```shell
# Environment Variables

export HOSTNAME="PLACEHOLDER"

export PORT="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export SWAP_SIZE="PLACEHOLDER"

export SWAP_FILE_PATH="PLACEHOLDER"

export COLLECTION_NAME="PLACEHOLDER"
```

## Debug

### Connect to the MongoDB instance
```shell
mongo ${HOSTNAME}:${PORT}
```

### List the databases
```shell
show dbs
```

### Select a database
```shell
use ${DATABASE_NAME}
```

### Check the size of all collections in the database
```shell
db.getCollectionNames().forEach(function(collname) { print(db.getCollection(collname).count() + "\t" + collname) })
```

### Check the virtual memory usage of the MongoDB instance
```shell
db.serverStatus().mem.virtual
```

### Check the available memory on the server
```shell
free -m
```

### Check the system logs for any memory-related errors
```shell
grep -i "out of memory" /var/log/syslog
```

### Check the MongoDB logs for any errors
```shell
tail -f /var/log/mongodb/mongod.log
```

### Check the resource usage of the MongoDB process
```shell
top -p $(pgrep mongod) -c
```

### Check the configuration file for any memory-related settings
```shell
cat /etc/mongod.conf | grep -i "memory"
```

## Repair

### Increase the swap space to allow MongoDB to use more virtual memory.
```shell


#!/bin/bash



# Get the current swap usage

SWAP=$(free | awk '/^Swap:/ {print $3}')



# Check if swap is already being used

if [ $SWAP -eq 0 ]; then

    # Increase the swap space by adding a new swap file

    sudo fallocate -l ${SWAP_SIZE} ${SWAP_FILE_PATH}

    sudo chmod 600 ${SWAP_FILE_PATH}

    sudo mkswap ${SWAP_FILE_PATH}

    sudo swapon ${SWAP_FILE_PATH}



    # Update the /etc/fstab file to enable the swap file at boot time

    echo "${SWAP_FILE_PATH} none swap sw 0 0" | sudo tee -a /etc/fstab



    # Verify the new swap space

    free

else

    echo "Swap space is already being used."

fi


```

### Optimize the MongoDB queries to reduce the memory usage.
```shell


#!/bin/bash



# Define the MongoDB database name and collection to optimize

DB_NAME=${DATABASE_NAME}

COLLECTION_NAME=${COLLECTION_NAME}



# Connect to the MongoDB instance and run the optimization command

mongo $DB_NAME --eval "db.$COLLECTION_NAME.reIndex()"



# Output a success message

echo "MongoDB query optimization and memory usage reduction complete."


```

### Remove unused indexes or collections to free up memory space.
```shell


#!/bin/bash



# Define the MongoDB database and collection to remove

database_name=${DATABASE_NAME}

collection_name=${COLLECTION_NAME}



# Connect to the MongoDB instance and remove the collection

mongo $database_name --eval "db.$collection_name.drop()"



# Print a message to confirm the collection was removed

echo "The $collection_name collection has been removed from the $database_name database."


```