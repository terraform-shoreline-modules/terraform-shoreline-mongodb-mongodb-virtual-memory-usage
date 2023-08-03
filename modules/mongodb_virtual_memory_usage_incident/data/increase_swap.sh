

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