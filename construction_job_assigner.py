
# Construction Company Job Assignment System
# Using Stack, Queue, and Recursion to manage worker-job assignments

from collections import deque
import random
import sqlite3

# --- Connect to external SQLite database to load workers and jobs ---
conn = sqlite3.connect("construction_company.db")
cursor = conn.cursor()

# Create tables if not exist (for testing/demo purposes)
cursor.execute("""
CREATE TABLE IF NOT EXISTS workers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    skills TEXT  -- comma-separated skills
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    job TEXT,
    type TEXT
)
""")

conn.commit()

# Fetch workers from database
cursor.execute("SELECT name, skills FROM workers")
workers_data = cursor.fetchall()
workers = [{"name": name, "skills": skills.split(",")} for name, skills in workers_data]

# Fetch jobs from database
cursor.execute("SELECT job, type FROM jobs")
jobs_data = cursor.fetchall()
job_queue = deque([{"job": job, "type": job_type} for job, job_type in jobs_data])

# Worker stack (LIFO)
worker_stack = list(workers)  # Most recently added worker is considered first

# Track job assignments
assignments = []

# Recursive function to assign jobs
def assign_jobs():
    if not job_queue:
        return  # Base case: all jobs assigned

    if not worker_stack:
        print("No more available workers to assign jobs.")
        return

    job = job_queue.popleft()
    worker = worker_stack.pop()

    if job["type"] in [skill.strip() for skill in worker["skills"]]:
        print(f"Assigning job '{job['job']}' ({job['type']}) to {worker['name']}")
        assignments.append((worker["name"], job["job"]))
    else:
        print(f"{worker['name']} does not have skills for '{job['job']}' ({job['type']}) — re-queuing job and putting worker back")
        job_queue.append(job)
        worker_stack.insert(0, worker)  # Push back to bottom of stack

    assign_jobs()  # Recursive call

# Run the job assignment
print("Starting job assignments...\n")
assign_jobs()

# Show final results
print("\nFinal Assignments:")
for name, job in assignments:
    print(f"- {name} -> {job}")

conn.close()
