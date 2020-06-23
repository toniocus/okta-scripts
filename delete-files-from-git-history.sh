#
# More than a script is a list of things to be done
# for more info see:
#
#      https://rtyley.github.io/bfg-repo-cleaner/
#

# clone AS A MIRROR
git clone --mirror git:my-repository

# Delete file from history
# See lot of other options running without arguments
java -jar $TA_HOME/etc/bfg-1.13.0.jar -D my-script.sh


# The BFG will update your commits and all branches and tags so they are clean, 
# but it doesn't physically delete the unwanted stuff. 
# Examine the repo to make sure your history has been updated, 
# and then use the standard git gc command to strip out the unwanted dirty data, 
# which Git will now recognise as surplus to requirements:
git reflog expire --expire=now --all && git gc --prune=now --aggressive


# finally push
git push --force

