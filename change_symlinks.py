import os

# List of directories to change
dirs = ['.cache', '.local', '.triton', 'code', 'experiments']

# Get the environment variables
home_dir = os.getenv('HOME')
work_dir = os.getenv('WORK')
scratch_dir = os.getenv('SCRATCH')

for dir in dirs:
    # Construct the old and new paths
    old_path = os.path.join(home_dir, dir)
    new_dir = dir.lstrip('.')  # Remove leading period
    new_path = os.path.join(scratch_dir, new_dir)

    # Check if the old path is a symlink and points to the expected location
    if os.path.islink(old_path) and os.readlink(old_path).startswith(work_dir):
        # Check if the new directory exists, if not create it
        if not os.path.exists(new_path):
            os.makedirs(new_path)

        # Remove the old symlink
        os.remove(old_path)

        # Create the new symlink
        os.symlink(new_path, old_path)
