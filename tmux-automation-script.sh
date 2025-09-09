# in ~/dev/shell/tmux-setup/tx

#!/bin/bash

# Function to create a new session with windows if it doesn't exist
create_session() {
    local session_name=$1
    local project_path=$2
    local second_window_name=$3
    local startup_command=$4  # Parameter for startup command
    
    # Check if session exists
    tmux has-session -t $session_name 2>/dev/null
    if [ $? != 0 ]; then
        # Create new session with first window named "cli"
        tmux new-session -d -s $session_name -n "cli" -c "$project_path"
        
        # Send startup command if provided
        if [ ! -z "$startup_command" ]; then
            tmux send-keys -t $session_name "$startup_command" C-m
        fi
        
        # Create additional windows in the same directory
        tmux new-window -t $session_name:1 -n "$second_window_name" -c "$project_path"
        tmux new-window -t $session_name:2 -n "git" -c "$project_path"
    fi
}

# Function to kill all tmux sessions and close Cursor windows
kill_all_sessions() {
    # Kill all tmux sessions
    tmux kill-server 2>/dev/null
    echo "All tmux sessions cleared"
    
    # Close all Cursor app instances
    # if pgrep -x "Cursor" > /dev/null; then
    #     echo "Closing Cursor app instances..."
    #     osascript -e 'tell application "Cursor" to quit'
    #     sleep 1
    # fi
}

# Function to list all tmux sessions
list_sessions() {
    if ! tmux list-sessions 2>/dev/null; then
        echo "No active tmux sessions"
    fi
}

# Function to handle GCP authentication for Siira
handle_siira_auth() {
    echo "Setting up Siira GCP authentication..."
    
    # Check if the current configuration is already siira
    current_config=$(gcloud config configurations list --format="value(name)" --filter="is_active=true")
    
    if [ "$current_config" != "siira" ]; then
        # First check if siira configuration exists
        if ! gcloud config configurations list --format="value(name)" | grep -q "^siira$"; then
            echo "Creating siira configuration..."
            gcloud config configurations create siira
        fi
        
        # Activate siira configuration
        gcloud config configurations activate siira
        
        # Set account
        gcloud config set account abakhach@siira.me
        
        # Check if authenticated, if not login
        if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q "abakhach@siira.me"; then
            echo "Authentication required for Siira..."
            gcloud auth login abakhach@siira.me
        fi
    else
        echo "Siira configuration already active"
    fi
}

# Function to handle GCP authentication for Rovera
handle_rovera_auth() {
    echo "Setting up Rovera GCP authentication..."
    
    # Check if the current configuration is already rovera
    current_config=$(gcloud config configurations list --format="value(name)" --filter="is_active=true")
    
    if [ "$current_config" != "rovera" ]; then
        # First check if rovera configuration exists
        if ! gcloud config configurations list --format="value(name)" | grep -q "^rovera$"; then
            echo "Creating rovera configuration..."
            gcloud config configurations create rovera
        fi
        
        # Activate rovera configuration
        gcloud config configurations activate rovera
        
        # Set account
        gcloud config set account abdullah@rovera.ai
        
        # Check if authenticated, if not login
        if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q "abdullah@rovera.ai"; then
            echo "Authentication required for Rovera..."
            gcloud auth login abdullah@rovera.ai
        fi
    else
        echo "Rovera configuration already active"
    fi
}

# Function to open Cursor app with specific folders
open_cursor_with_folder() {
    local folder_path=$1
    
    # Check if the folder exists
    if [ ! -d "$folder_path" ]; then
        echo "Folder does not exist: $folder_path"
        return 1
    fi
    
    # Open Cursor with the specified folder
    # echo "Opening Cursor with folder: $folder_path"
    # open -a Cursor "$folder_path"
    # sleep 1  # Give it a moment to open
}

setup_momen_demo() {
    local app_name="momen-demo"
    
    # Create backend session with windows
    create_session "backend-$app_name" "/Users/abdullahbakhach/dev/js/momen-oori-demo-project/you-app-backend" "bac"
    
    # Create frontend session with windows
    create_session "frontend-$app_name" "/Users/abdullahbakhach/dev/js/momen-oori-demo-project/you-app-frontend" "web"
    
    # Attach to the backend session
    tmux attach-session -t "backend-$app_name"
}

# Function to setup Siira project
setup_siira() {
    local app_name="siira"
    
    # Handle Siira authentication first
    handle_siira_auth
    
    # Close any existing Cursor windows
    # if pgrep -x "Cursor" > /dev/null; then
    #     echo "Closing existing Cursor windows..."
    #     osascript -e 'tell application "Cursor" to quit'
    #     sleep 1
    # fi
    
    # Open Cursor with frontend and backend folders
    # open_cursor_with_folder "/Users/abdullahbakhach/dev/js/siira-admin"
    # open_cursor_with_folder "/Users/abdullahbakhach/dev/js/siira-backend"
    
    # Create web session with npm run dev command
    create_session "web-$app_name" "/Users/abdullahbakhach/dev/js/siira-admin" "web" "npm run dev"
    
    # Create bac session with npm run start:staging command
    create_session "bac-$app_name" "/Users/abdullahbakhach/dev/js/siira-backend" "bac" "npm run start:staging"
    
    # Create mobile session
    create_session "mobile-$app_name" "/Users/abdullahbakhach/dev/flutter/siira-mobile" "mobile"
    
    # Create db session and setup SSH tunnel
    tmux new-session -d -s "db-$app_name" -n "db"
    
    # No need to activate siira config here since we already did it at the beginning
    tmux send-keys -t "db-$app_name" "echo 'Setting up SSH tunnel for Siira DB...'" C-m
    tmux send-keys -t "db-$app_name" "gcloud compute ssh --project=linear-outcome-392912 --zone=us-central1-a staging-siira-bastion -- -NL 7777:172.18.81.3:5432" C-m
    
    # Create Redis tab in the db session
    tmux new-window -t "db-$app_name:1" -n "redis" -c "/Users/abdullahbakhach/dev/js/siira-backend"
    
    # Start Docker Desktop if it's not running and run docker-compose
    tmux send-keys -t "db-$app_name:1" "echo 'Starting Docker and Redis services...'" C-m
    tmux send-keys -t "db-$app_name:1" "open -a Docker" C-m
    tmux send-keys -t "db-$app_name:1" "sleep 5" C-m
    tmux send-keys -t "db-$app_name:1" "docker-compose up -d" C-m
    
    # Create git window
    tmux new-window -t "db-$app_name:2" -n "git" -c "/Users/abdullahbakhach/dev/js/siira-backend"
    
    # Attach to the web session
    tmux attach-session -t "web-$app_name"
}

# Function to setup Siira-AI project
setup_siira_ai() {
    local app_name="siira-ai"
    local project_path="/Users/abdullahbakhach/dev/python/Siira"
    
    # Handle Siira authentication first
    handle_siira_auth
    
    # Close any existing Cursor windows
    # if pgrep -x "Cursor" > /dev/null; then
    #     echo "Closing existing Cursor windows..."
    #     osascript -e 'tell application "Cursor" to quit'
    #     sleep 1
    # fi
    
    # Open Cursor with the project folder
    # open_cursor_with_folder "$project_path"
    
    # Create siira-ai session with standard windows
    create_session "$app_name" "$project_path" "siira-ai"
    
    # Attach to the siira-ai session
    tmux attach-session -t "$app_name"
}

# Function to setup Rovera project
# Function to setup Rovera project
setup_rovera() {
    local app_name="rovera"
    
    # Handle Rovera authentication first
    handle_rovera_auth
    
    # Close any existing Cursor windows
    # if pgrep -x "Cursor" > /dev/null; then
    #     echo "Closing existing Cursor windows..."
    #     osascript -e 'tell application "Cursor" to quit'
    #     sleep 1
    # fi
    
    # Open Cursor with frontend and backend folders
    # open_cursor_with_folder "/Users/abdullahbakhach/dev/js/rovera-frontend"
    # open_cursor_with_folder "/Users/abdullahbakhach/dev/js/rovera-backend"
    
    # Create web session with correct path for all windows
    create_session "web-$app_name" "/Users/abdullahbakhach/dev/js/rovera-frontend" "web" "npm run dev"
    
    # Create bac session with correct path for all windows
    create_session "bac-$app_name" "/Users/abdullahbakhach/dev/js/rovera-backend" "bac" "npm run start:staging"
    
    # Create homepage session with cli, homepage, and git windows
    create_session "homepage-$app_name" "/Users/abdullahbakhach/dev/js/rovera-landing" "homepage"
    
    # Create db session with GCP config and tunnel
    tmux new-session -d -s "db-$app_name" -n "db"
    
    # No need to activate rovera config here since we already did it at the beginning
    tmux send-keys -t "db-$app_name" "echo 'Setting up SSH tunnel for Rovera DB...'" C-m
    tmux send-keys -t "db-$app_name" "gcloud --project=jovial-coral-443911-f2 compute ssh --zone=us-central1-a staging-main-backend-node -- -NL 6666:10.134.2.3:5432" C-m
    
    # Attach to the web session
    tmux attach-session -t "web-$app_name"
}

# Function to setup Rovera POC project
setup_rovera_poc() {
    local app_name="rovera-poc"
    
    # Handle Rovera authentication first
    handle_rovera_auth
    
    # Close any existing Cursor windows
    # if pgrep -x "Cursor" > /dev/null; then
    #     echo "Closing existing Cursor windows..."
    #     osascript -e 'tell application "Cursor" to quit'
    #     sleep 1
    # fi
    
    # Open Cursor with frontend and backend folders
    # open_cursor_with_folder "/Users/abdullahbakhach/dev/js/rovera-web-poc"
    # open_cursor_with_folder "/Users/abdullahbakhach/dev/js/rovera-backend-poc"
    
    # Create backend session with windows
    create_session "backend-$app_name" "/Users/abdullahbakhach/dev/js/rovera-backend-poc" "bac"
    
    # Create frontend session with windows
    create_session "frontend-$app_name" "/Users/abdullahbakhach/dev/js/rovera-web-poc" "web"
    
    # Attach to the backend session
    tmux attach-session -t "backend-$app_name"
}

# Function to setup Oori Legacy project (previous Oori setup)
setup_oori_legacy() {
    local app_name="oori-legacy"
    local project_path="/Users/abdullahbakhach/dev/php/oori/investor-portal"
    
    # Close any existing Cursor windows
    # if pgrep -x "Cursor" > /dev/null; then
    #     echo "Closing existing Cursor windows..."
    #     osascript -e 'tell application "Cursor" to quit'
    #     sleep 1
    # fi
    
    # Open Cursor with the project folder
    # open_cursor_with_folder "$project_path"
    
    # Check if session exists
    tmux has-session -t "$app_name" 2>/dev/null
    if [ $? != 0 ]; then
        # Create new session with first window named "cli"
        tmux new-session -d -s "$app_name" -n "cli" -c "$project_path"
        
        # Split the cli window into two panes
        tmux split-window -v -t "$app_name:0" -c "$project_path"
        
        # Send php artisan serve to the first pane
        tmux send-keys -t "$app_name:0.0" "php artisan serve" C-m
        
        # Send npm run dev to the second pane
        tmux send-keys -t "$app_name:0.1" "npm run dev" C-m
        
        # Create additional windows in the same directory
        tmux new-window -t "$app_name:1" -n "oori" -c "$project_path"
        tmux new-window -t "$app_name:2" -n "git" -c "$project_path"
    fi
    
    # Attach to the oori-legacy session
    tmux attach-session -t "$app_name"
}

# Function to setup Oori project
setup_oori() {
    local app_name="oori"
    local bac_path="/Users/abdullahbakhach/dev/js/oori-api"
    local mobile_path="/Users/abdullahbakhach/dev/android/oori-android"
    local web_path="/Users/abdullahbakhach/dev/js/oori-web"
    
    # Create bac session with windows
    create_session "bac-$app_name" "$bac_path" "bac"
    
    # Create mobile session with windows
    create_session "mobile-$app_name" "$mobile_path" "mobile"
    
    # Create web session with windows
    create_session "web-$app_name" "$web_path" "web"
    
    # Attach to the bac session
    tmux attach-session -t "bac-$app_name"
}

# Function to setup Awsini project
setup_awsini() {
    local app_name="awsini"
    local project_path="/Users/abdullahbakhach/dev/flutter/awsini"
    
    # Close any existing Cursor windows
    # if pgrep -x "Cursor" > /dev/null; then
    #     echo "Closing existing Cursor windows..."
    #     osascript -e 'tell application "Cursor" to quit'
    #     sleep 1
    # fi
    
    # Open Cursor with the project folder
    # open_cursor_with_folder "$project_path"
    
    # Create awsini session
    create_session "$app_name" "$project_path" "awsini"
    
    # Attach to the awsini session
    tmux attach-session -t "$app_name"
}

# Function to check current tmux setup - this will need to be updated to handle multiple setups
get_current_setup() {
    # Check if tmux is running
    if ! tmux ls &>/dev/null; then
        echo "No active tmux sessions"
        return 1  # Add return code
    fi

    # List all sessions that match our pattern
    echo "Active project sessions:"
    
    # Check for siira sessions
    if tmux has-session -t "db-siira" 2>/dev/null; then
        echo "- siira"
    fi
    
    # Check for siira-ai sessions
    if tmux has-session -t "siira-ai" 2>/dev/null; then
        echo "- siira-ai"
    fi
    
    # Check for rovera sessions
    if tmux has-session -t "db-rovera" 2>/dev/null; then
        echo "- rovera"
    fi
    
    # Check for rovera-poc sessions
    if tmux has-session -t "backend-rovera-poc" 2>/dev/null; then
        echo "- rovera-poc"
    fi
    
    # Check for oori sessions
    if tmux has-session -t "bac-oori" 2>/dev/null; then
        echo "- oori"
    fi
    
    # Check for oori-legacy session
    if tmux has-session -t "oori-legacy" 2>/dev/null; then
        echo "- oori-legacy"
    fi
    
    # Check for awsini session
    if tmux has-session -t "awsini" 2>/dev/null; then
        echo "- awsini"
    fi

     # Check for momen-demo sessions
    if tmux has-session -t "backend-momen-demo" 2>/dev/null; then
        echo "- momen-demo"
    fi
    
    # Show current GCP configuration
    echo ""
    echo "Current GCP configuration:"
    gcloud config configurations list --filter="is_active=true" --format="table(name, account, project)"
    
    # Check for Cursor instances
    echo ""
    # if pgrep -x "Cursor" > /dev/null; then
    #     echo "Cursor app is running"
    #     echo "Cursor may have these folders open:"
    #     osascript -e 'tell application "Cursor" to get name of windows' 2>/dev/null || echo "  (Unable to retrieve window information)"
    # else
    #     echo "Cursor app is not running"
    # fi
    
    return 0
}

# Main command handling
case "$1" in
    "clear")
        kill_all_sessions
        ;;
    "siira")
        setup_siira
        ;;
    "siira-ai")
        setup_siira_ai
        ;;
    "rovera")
        setup_rovera
        ;;
    "rovera-poc")
        setup_rovera_poc
        ;;
    "oori-legacy")
        setup_oori_legacy
        ;;
    "oori")
        setup_oori
        ;;
    "awsini")
        setup_awsini
        ;;
    "momen-demo")
        setup_momen_demo
        ;;
    "ls")
        list_sessions
        ;;
    "current")
        get_current_setup
        ;;
    *)
        echo "Usage: $0 {clear|siira|siira-ai|rovera|rovera-poc|oori|oori-legacy|awsini|ls|current}"
        echo "  clear       - Kill all existing tmux sessions"
        echo "  siira       - Setup tmux sessions for Siira project"
        echo "  siira-ai    - Setup tmux session for Siira AI project"
        echo "  rovera      - Setup tmux sessions for Rovera project"
        echo "  rovera-poc  - Setup tmux sessions for Rovera POC project"
        echo "  oori-legacy - Setup tmux session for Oori investor portal (PHP)"
        echo "  oori        - Setup tmux sessions for Oori project (bac, mobile, web)"
        echo "  awsini      - Setup tmux session for Awsini project"
        echo "  momen-demo  - Setup tmux sessions for Momen Demo project"
        echo "  ls          - List all active tmux sessions"
        echo "  current     - Show current tmux setup and GCP configuration"
        exit 1
        ;;
esac
