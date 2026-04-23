import subprocess
import sys

scripts = [
    ("1_import_data.py", "Step 1: Loading images and extracting features"),
    ("2_clean_and_shape_data.py", "Step 2: Cleaning data and removing outliers"),
    ("3_build_model.py", "Step 3: Training models and generating predictions")
]

print("\nStarting pipeline...\n")

for script, description in scripts:
    print(f"----------------------------------------")
    print(f"{description}")
    print(f"Running {script}...\n")

    try:
        result = subprocess.run([sys.executable, script], check=True)
        print(f"\nFinished {script} successfully\n")
    except subprocess.CalledProcessError:
        print(f"\nError while running {script}")
        sys.exit(1)

print("----------------------------------------")
print("Pipeline completed successfully!")