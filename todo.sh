#!/bin/bash
TODO="todos.txt"

# Function to validate date and time format
is_valid_datetime() {
  local datetime="$1"
  if [[ "$datetime" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}$ ]]; then
    return 0  # Valid
  else
    return 1  # Invalid
  fi
}

# Function to validate date format
is_valid_date() {
  local date="$1"
  if [[ "$date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    return 0  # Valid
  else
    return 1  # Invalid
  fi
}

create_task() {
  echo "Creating a new task..."

  # Input validation with error messages to stderr
  read -p "Title (required): " title
  if [ -z "$title" ]; then
    echo "Error: Title is required." >&2
    return 1
  fi

  read -p "description: " desc
  read -p "location: " location

  #verification for date and time
  read -p "date and time (YYYY-MM-DD HH:MM, are required): " time
  if [ -z "$time" ]; then
    echo "error: date and time of the task are required " >&2
    return 1
  elif ! is_valid_datetime "$time"; then
    echo "error: Invalid date and time format, use this format YYYY-MM-DD HH:MM " >&2
    return 1
  fi

  #Generate a unique id (using date and time for uniqueness)
  identifier="$(date +"%Y%m%d%H%M%S")"

  #Save the task to the txt file
  echo "$identifier|$title|$desc|$location|$time|not_completed" >> "$TODO"
  echo "Task '$title' created successfully."
}
#verification if the user has entered an argument
update_task() {
  if [[ $# -lt 1 ]]; then
    echo "error: please provide the task id to update " >&2
    return 1
  fi

  identifier="$1"

  #Check if the task with the given identifier exists
  if ! grep -q "^$identifier" "$TODO"; then
    echo "error: task with identifier $identifier not found " >&2
    return 1
  fi

  #Prompt the user to update fields
  echo "Enter the updated title of the task (leave empty to keep current):"
  read title
  echo "Enter the updated description of the task (leave empty to keep current):"
  read desc
  echo "Enter the updated location of the task (leave empty to keep current):"
  read location
  echo "Enter the updated due date and time of the task in format 'YYYY-MM-DD HH:MM' (leave empty to keep current):"
  read time

  #Read the existing data of the task
  existing_data=$(grep "^$identifier" "$TODO")

  #Extract existing values
  existing_title=$(echo "$existing_data" | cut -d'|' -f2)
  existing_desc=$(echo "$existing_data" | cut -d'|' -f3)
  existing_location=$(echo "$existing_data" | cut -d'|' -f4)
  existing_time=$(echo "$existing_data" | cut -d'|' -f5)

  #Update values if user input is not empty
  if [ -n "$title" ]; then
    existing_title="$title"
  fi
  if [ -n "$desc" ]; then
    existing_desc="$desc"
  fi
  if [ -n "$location" ]; then
    existing_location="$location"
  fi
  if [ -n "$time" ]; then
    existing_time="$time"
  fi

  #Replace the old line with the updated one in the file
  sed -i "s/^$identifier.*/$identifier|$existing_title|$existing_desc|$existing_location|$existing_time|not_completed/" "$TODO"

  echo "The task has been successfully updated "
}

delete_task() {
  if [[ $# -lt 1 ]]; then
    echo "error:please enter a task id to delete " >&2
    return 1
  fi

  identifier="$1"

  #check if the task with the given id exists or not in the txt file
  if ! grep -q "^$identifier" "$TODO"; then
    echo "error: the task with the id $identifier is not found " >&2
    return 1
  fi

  #delete the task from the txt file using task id
  sed -i "/^$identifier/d" "$TODO"
  echo "task with id $identifier deleted successfully "
}

show_task() {
  if [[ $# -lt 1 ]]; then
    echo "error: provide a task id to show" >&2
    return 1
  fi

  identifier="$1"

  #check if the task with the provided id exists in the txt file
  if ! grep -q "^$identifier" "$TODO"; then
    echo "error: Task with identifier $identifier not found " >&2
    return 1
  fi

  # Display information about the task, with labels
  task_line=$(grep "^$identifier" "$TODO")
  IFS='|' read -r identifier title description location time completed <<< "$task_line"
  echo "Task Details:"
  echo "  ID: $identifier"
  echo "  Title: $title"
  echo "  Description: $description"
  echo "  Location: $location"
  echo "  Due: $time"
  echo "  Status: $completed"
}

# list_tasks: Lists tasks for a specified date, categorized into uncompleted and completed tasks.
list_tasks() {
  if [[ $# -lt 1 ]]; then     # Check if a date argument was provided
    echo "Error: Please provide a date in format YYYY-MM-DD." >&2 
    return 1                 # Exit with an error code if date is missing
  fi

  date="$1"                  # Assign the provided date to the variable 'date'

  if ! is_valid_date "$date"; then  # Check if the date format is valid (YYYY-MM-DD)
    echo "error: Invalid date format, please use YYYY-MM-DD " >&2
    return 1                 # Exit with an error code if date format is invalid
  fi

  echo "Tasks for $date:"    # Display a header with the selected date

  # Display uncompleted tasks
  echo "Uncompleted tasks:"
  while IFS='|' read -r identifier title description location time completed; do 
    task_date=$(echo "$time" | cut -d' ' -f1)  # Extract the date from the time field
    if [[ "$task_date" == "$date" && "$completed" == "not_completed" ]]; then  # Check if task date matches and is not completed
      echo "- $title ($location) [Due: $time]"  # Display task details
    fi
  done < "$TODO"             # Read tasks from the TODO file

  # Display completed tasks (similar logic to uncompleted tasks)
  echo "Completed tasks:"
  while IFS='|' read -r identifier title description location time completed; do
    task_date=$(echo "$time" | cut -d' ' -f1)  # Extract the date from the time field
    if [[ "$task_date" == "$date" && "$completed" == "completed" ]]; then  # Check if task date matches and is completed
      echo "- $title ($location) [Due: $time]"  # Display task details
    fi
  done < "$TODO"            # Read tasks from the TODO file
}

# search_task: Searches for tasks by title or description and shows their completion status.
search_task() {
  if [[ $# -lt 1 ]]; then    # Check if a search term was provided
    echo "Error: Please provide a search term." >&2
    return 1                 # Exit with an error code if search term is missing
  fi

  search_term="$1"           # Assign the provided search term

  echo "Tasks matching '$search_term':"

  # Loop through tasks, searching by title or description
  while IFS='|' read -r identifier title description location time completed; do 
    if [[ "$title" == "$search_term" || "$description" == "$search_term" ]]; then
      status="Not Completed"   # Default status
      if [[ "$completed" == "completed" ]]; then
        status="Completed"     # Update status if task is completed
      fi
      echo "- $title ($location) [Due: $time] [$status]" # Display task details with status
    fi
  done < "$TODO"             # Read tasks from the TODO file
}

# complete_task: Marks a task as completed by its ID.
complete_task() {
  if [[ $# -lt 1 ]]; then    # Check if a task ID was provided
    echo "Error: Please provide a task ID to mark as completed." >&2
    return 1                 # Exit with an error code if task ID is missing
  fi

  identifier="$1"            # Assign the provided task ID

  #Check if the task with the given identifier exists
  if ! grep -q "^$identifier" "$TODO"; then
    echo "Error: Task with identifier $identifier not found." >&2
    return 1
  fi

  #Read the existing data of the task
  existing_data=$(grep "^$identifier" "$TODO")

  # Extract existing values
  existing_title=$(echo "$existing_data" | cut -d'|' -f2)
  existing_desc=$(echo "$existing_data" | cut -d'|' -f3)
  existing_location=$(echo "$existing_data" | cut -d'|' -f4)
  existing_time=$(echo "$existing_data" | cut -d'|' -f5)

  #Replace the old line with the updated one in the file
  sed -i "s/^$identifier.*/$identifier|$existing_title|$existing_desc|$existing_location|$existing_time|completed/" "$TODO"

  echo "Task with identifier $identifier marked as completed."
}

#Main logic
if [ $# -eq 0 ]; then
  list_tasks "$(date +%Y-%m-%d)"  # Default to today if no arguments
else
  case "$1" in
    create)
      create_task
      ;;
    update)
      update_task "$2"
      ;;
    delete)
      delete_task "$2"
      ;;
    show)
      show_task "$2"
      ;;
    list)
      if [ $# -eq 1 ]; then
        echo "Error: Please provide a date in format YYYY-MM-DD." >&2
        exit 1
      else
        if ! is_valid_date "$2"; then
          echo "error: invalid date format, please use this format YYYY-MM-DD " >&2
          exit 1
        fi
        list_tasks "$2"
      fi
      ;;
    search)
      search_task "$2"
      ;;
    complete)
      complete_task "$2"
      ;;
    *)
      echo "invalid command, usage: $0 [create|update|delete|show|list|search|complete] " >&2
      exit 1
      ;;
  esac
fi
