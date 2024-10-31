#!/bin/sh


# The file to be checked and modified
FILE="launcher.cnl"

# The lines to search for and replace (config path)
search_config_path="#var cloudnet.config.json.path config.json"
replace_config_path="var cloudnet.config.json.path config/config.json"

# The lines to search for and replace (auto-update)
update_line_true="var cloudnet.auto.update true"
update_line_false="var cloudnet.auto.update false"

# Check if the config path line exists and replace it
if grep -q "^$search_config_path" "$FILE"; then
    # If the line is found, replace it
    sed -i "s|^$search_config_path|$replace_config_path|" "$FILE"
    echo "Config path line has been modified."
elif grep -q "^$replace_config_path" "$FILE"; then
    # If the correct line is already present, do nothing
    echo "Config path line is already correct."
else
    # If neither line is found, print a message and exit the script
    echo "Config path line was not found. Exiting."
    exit 1
fi

# Check the AUTOUPDATE environment variable
if [ "$AUTOUPDATE" = "true" ]; then
    # Replace or set the update line to "true"
    if grep -q "^var cloudnet.auto.update" "$FILE"; then
        sed -i "s|^var cloudnet.auto.update .*|$update_line_true|" "$FILE"
    else
        echo "$update_line_true" >> "$FILE"
    fi
    echo "AUTOUPDATE is set to true. The update line has been set to true."
elif [ "$AUTOUPDATE" = "false" ]; then
    # Replace or set the update line to "false"
    if grep -q "^var cloudnet.auto.update" "$FILE"; then
        sed -i "s|^var cloudnet.auto.update .*|$update_line_false|" "$FILE"
    else
        echo "$update_line_false" >> "$FILE"
    fi
    echo "AUTOUPDATE is set to false. The update line has been set to false."
else
    echo "AUTOUPDATE environment variable is not set or invalid. Exiting."
    exit 1
fi




cd "$(dirname "$(readlink -fn "$0")")" || exit 1

# check if java is installed
if [ -x "$(command -v java)" ]; then
  # if screen is present use that
  # this check is elevated as tmux is sometimes present by default
  if [ -x "$(command -v screen)" ]; then
    # DO NOT CHANGE THE SUPPLIED MEMORY HERE. THIS HAS NO EFFECT ON THE NODE INSTANCE. USE THE launcher.cnl INSTEAD
    screen -DRSq CloudNet java -Xms$XMS -Xmx$XMX -XX:+UseZGC -XX:+PerfDisableSharedMem -XX:+DisableExplicitGC -jar launcher.jar
  elif [ -x "$(command -v tmux)" ]; then
    # DO NOT CHANGE THE SUPPLIED MEMORY HERE. THIS HAS NO EFFECT ON THE NODE INSTANCE. USE THE launcher.cnl INSTEAD
    tmux new-session -As CloudNet java -Xms$XMS -Xmx$XMX -XX:+UseZGC -XX:+PerfDisableSharedMem -XX:+DisableExplicitGC -jar launcher.jar \; set -g status off
  else
    echo "No screen or tmux installation found, you need to install at least one of them to run CloudNet"
    exit 1
  fi
else
  echo "No valid java installation was found, please install java in order to run CloudNet"
  exit 1
fi
