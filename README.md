# Containment
cd ~/devel/src/Containment/

Then the following will work

First make a new branch to store your changes in:
git checkout -b branch_name

Then once you have made changes, add those changes. This is called staging:
git add .

The above command adds all changes from the current directory and below to the staged changes that will be commited with the next command.

git commit -m "A message describing the changes you made"

Then you need to push those changes to the remote origin... In this case that is github.
git push

