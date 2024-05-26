# 📝 Task Management Made Easy 🚀

Welcome to the **Simple To-Do List Manager**! This command-line tool is your go-to solution for keeping track of tasks and managing your schedule effortlessly.

## ✨ Features ✨

* **Quick Task Creation:** Easily add tasks with titles, descriptions, locations, and due dates/times.
* **Simple Updates:** Update any detail of your existing tasks with ease.
* **Easy Deletion:** Remove tasks you no longer need in a snap.
* **Detailed Task View:** Get a comprehensive overview of any task.
* **Organized Lists:** See all your tasks for a specific date, divided into completed and uncompleted sections.
* **Powerful Search:** Quickly find tasks by searching for keywords in the title or description.
* **Completion Tracking:** Mark tasks as completed to track your progress.

## 🛠️ How to Use 🛠️

1. **Make the Script Executable:**
    ```bash
    chmod +x todo.sh
    ```

2. **Use the Commands:**

    * **Add a New Task:**
        ```bash
        ./todo.sh create
        ```
        Just follow the prompts to enter the task details.

    * **View Today's Tasks:**
        ```bash
        ./todo.sh list
        ```

    * **View Tasks for a Specific Date:**
        ```bash
        ./todo.sh list YYYY-MM-DD
        ```
        Replace `YYYY-MM-DD` with the date you want to check.

    * **All Available Commands:**
        ```bash
        ./todo.sh create             # Add a new task
        ./todo.sh update <task_id>   # Update an existing task
        ./todo.sh delete <task_id>   # Delete a task
        ./todo.sh show <task_id>     # Show details of a task
        ./todo.sh search <search_term>   # Search for tasks
        ./todo.sh complete <task_id> # Mark a task as completed
        ./todo.sh list <date>        # List tasks for a specific date (replace <date> with a date in the format YYYY-MM-DD)
        ./todo.sh                    # List all tasks for today
        ```

## 📂 Data Storage 📂

Your tasks are saved in a file called `todos.txt`. Each task is stored on a single line, with fields separated by a pipe (`|`) character:

