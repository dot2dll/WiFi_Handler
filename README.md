# WiFi Handler

## Introduction

This script is designed to facilitate Wi-Fi connection on a Raspberry Pi by looping through known Wi-Fi networks and attempting to connect to them. It's particularly useful for Raspberry Pi setups in changing network, the device doesn't automatically store Wi-Fi credentials or connect to networks like conventional systems. This is especially handy in headless configurations where user can not interact with the Raspberry Pi using a monitor and keyboard.

## Usage

1. **Clone the Repository**: Clone this repository to your Raspberry Pi:

    ```
    git clone <repository_url>
    ```

2. **Navigate to the Directory**: Enter the directory where the script is located:

    ```
    cd <repository_directory>
    ```

3. **Make the Script Executable**: Ensure that the script has execute permissions:

    ```
    chmod +x auto_connect_wifi.sh
    ```

4. **Edit the Script**: Modify the script to include the Wi-Fi networks and their passwords in the `list_of_wifi` array.

5. **Run the Script**: Execute the script to initiate the Wi-Fi connection process:

    ```
    ./auto_connect_wifi.sh
    ```

6. **Automate on System Reboot**: To ensure the script runs on system reboot, set up a cron job as follows:
   
    - Open the crontab for editing:
      ```
      crontab -e
      ```
    - Add the following line to the crontab file to run the script on reboot:
      ```
      @reboot /path/to/auto_connect_wifi.sh
      ```
    - Save and exit the crontab editor. The script will now run automatically each time the system reboots.

## Script Details

- The script iterates through a list of known Wi-Fi networks defined in the `list_of_wifi` array.
- For each network, it attempts to connect using the `nmcli` command-line tool.
- Connection attempts are logged, including successes and failures, to a log file.

## Dependencies

- This script relies on the `nmcli` tool, which is commonly installed on Raspberry Pi systems to manage network connections.

## Notes

- Ensure that your Raspberry Pi has the necessary network hardware and drivers installed and configured.
- This script is especially useful in headless configurations where direct user interaction with the Raspberry Pi is limited or not possible.