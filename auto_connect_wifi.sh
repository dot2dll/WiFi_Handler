#! /bin/bash

declare -A list_of_wifi

max_try=5
list_of_wifi=(
  ["ssid1"]="password1"
  ["ssid2"]="password2"
  ["ssid3"]="password3"
)

log_file=$0           # get the name of the script
log_file="${log_file%.*}.log"   # remove extension and add .log

log_to_file() {
  # purpose: log messages to a file
  # argument: message to log
  # date format: yyyy-mm-dd HH:MM:SS
  # $1 is the first argument passed to the function
  # example: log_to_file "This is a log message"
  echo "$(date +%Y-%m-%d\ %H:%M:%S) $1" >> $log_file
}

is_wifi_on() {
  # purpose: check if wifi is on, if not turn it on
  is_on=$(nmcli radio wifi | grep enabled) # if disabled, it will return empty. else return non-empty string
  if [ -n "$is_on" ]; then # if $is_on is not empty
    log_to_file "Wifi is on"
    return 0
  else
    log_to_file "Wifi is off, turning on"
    nmcli radio wifi on
    if [ $? -eq 0 ]; then # if the previous command was successful (exit status 0)
      log_to_file "Wifi turned on"
      return 0
    else
      log_to_file "Could not turn on wifi"
      return 1
    fi
  fi
}

is_connected() {
  # purpose: check if wifi is connected
  is_wifi_connected=$(nmcli dev status | grep wifi | grep connected | grep -v disconnected) # if disconnected, it will return empty. else return non-empty string
  if [ -n "$is_wifi_connected" ]; then # if $is_wifi_connected is not empty
    log_to_file "Wifi connected"
    return 0
  else
    log_to_file "Wifi not connected, trying to connect"
    return 1
  fi
}

connect_to_wifi() {
  # purpose: connect to wifi from the list_of_wifi
  for wifi in "${!list_of_wifi[@]}"; do # iterate through the keys of the associative array
    log_to_file "Trying to connect to $wifi"
    nmcli dev wifi connect "$wifi" password "${list_of_wifi[$wifi]}" 
    if [ $? -eq 0 ]; then # if the previous command was successful (exit status 0)
      log_to_file "Connected to $wifi"
      return 0
    else
      log_to_file "Could not connect to $wifi"
    fi
  done
  return 1
}

if ! is_wifi_on; then # if is_wifi_on returns 1
  log_to_file "Exiting"
  exit 1
fi

until is_connected; do # until is_connected returns 0
  connect_to_wifi # try to connect to wifi
  if [ $? -eq 0 ]; then # if the previous command was successful (exit status 0)
    exit 0
  else
    log_to_file "Retrying to connect to wifi after 15s"
    max_try=$((max_try-1)) # decrement max_try by 1
    if [ $max_try -eq 0 ]; then # if max_try is 0
      log_to_file "Max tries reached, exiting"
      exit 1
    else sleep 15 
    fi
  fi
done