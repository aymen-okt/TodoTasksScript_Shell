# 📝 Task Management Made Easy 🚀

Welcome to the **Simple To-Do List Manager**, your command-line companion for organizing tasks and staying on top of your schedule!

## ✨ Features ✨

*   **Effortless Task Creation:**  Quickly add new tasks with titles, descriptions, locations, and due dates/times.
*   **Flexible Updates:** Easily modify any detail of your existing tasks.
*   **Swift Task Removal:**  Delete tasks you no longer need.
*   **Detailed Task View:** Get a clear overview of a specific task's information.
*   **Organized Lists:** View all your tasks for a specific date, categorized into completed and uncompleted.
*   **Powerful Search:** Find tasks quickly using keywords in the title or description.
*   **Complete Tracking:** Mark tasks as completed for a sense of accomplishment.

## 🛠️ How to Use 🛠️

1.  **Make it Executable:**
    ```bash
    chmod +x todo.sh
    ```

2.  **Command Line Magic:**

    *   **Add a Task:**
        ```bash
        ./todo.sh create
        ```
        Follow the prompts to enter task details.

    *   **See Today's Tasks:**
        ```bash
        ./todo.sh list
        ```
        
    *   **Tasks for a Specific Date:**
        ```bash
        ./todo.sh list YYYY-MM-DD
        ```
        (Replace `YYYY-MM-DD` with the desired date)

    *   **All Commands:**
        ```bash
        ./todo.sh create             #Create a Task
        ./todo.sh update <task_id>   # Update a task
        ./todo.sh delete <task_id>   # Delete a task
        ./todo.sh show <task_id>     # Show task details
        ./todo.sh search <search_term>   # Search tasks
        ./todo.sh complete <task_id> # Mark task as done
        ./todo.sh list <date>        #List Tasks for a Specific Date (replace <date> with a date with this format YYYY-MM-DD), listing tasks in 2 sections (completed and uncompleted)
        ./todo.sh                    #this command with no arguments list to you all tasks created at the current day

        ```

## 📂 Data Storage 📂

Your tasks are stored in the `todos.txt` file. Each task is neatly organized in a single line using the pipe (`|`) symbol as a delimiter:
Unique_ID | Title | Description | Location | Due_Date_Time | Completion_Status

