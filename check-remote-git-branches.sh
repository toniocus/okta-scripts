
echo "---------------------------------------------------------------"
echo " Merged branches"
echo "---------------------------------------------------------------"

for branch in $(git branch -r --merged | grep -v HEAD) 
do 
   echo -e $(git show --format="%ci %cr %an" $branch | head -n 1) $branch 
done | sort -r 

echo 
echo
echo "---------------------------------------------------------------"
echo " NO-Merged branches"
echo "---------------------------------------------------------------"

for branch in $(git branch -r --no-merged | grep -v HEAD) 
do 
   echo -e $(git show --format="%ci %cr %an" $branch | head -n 1) $branch 
done | sort -r 
