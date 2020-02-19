#
#
#  Delete docker-images from a container
#
#

IMAGES="/tmp/images.$$"
IMAGETAGS="/tmp/imagetags.$$"
DATE=$(date -Idate -d"-30 days")
FILTER="ta-mvp"
dryRun="true"

if [ -z $1 ]; then
   echo "$0 repository-name (Ex.: ta-xxxx-callout) ta/ will be prepended to it if not present"
   exit 1;
fi

if [ "$2" = "run" ]; then
   dryRun="false"
fi


REPO=$(echo $1 | sed 's:/$::')
if [ ${REPO:0:3} != "ta/" ]; then
    REPO=ta/$REPO
fi

if [ $dryRun = "false" ]; then
   echo "Deleting pods from container. [ENTER] to continue"
   read kk
else
   echo "DryRun, no pods will be deleted....."
fi

echo "Finding deployments of $REPO ..."


# this will generate a file with this format
#
# ta-develop,2018-08-01T22:30:00Z,ta-develop-888
#
# ordered by ta-develop, date descending
#
# Description 
# environ   what comes before the build number
# date  the date when the image was deployed
# tag-name  the tag-name to be deleted

aws ecr describe-images --repository $REPO --max-items 500 | \
   jq -r '.imageDetails[] | (.imagePushedAt  | todateiso8601) + "|" + .imageTags[0]' | \
   sed -r 's/([^|]+)\|([^|]+)-([^-]+$)/\2,\1,\2-\3/' | \
   sort -t, -k1,1 -k2,2r > $IMAGES

# Generate a file with the images to be deleted.

# Delete all the images except the last 2 deployed
# assuming build # is the way to recognize it.

awk -F, -v repo=$REPO 'BEGIN { currentEnv = ""; envCounter = 0; }
{
   if (currentEnv != $1) {
      currentEnv = $1;
      envCounter = 1;
   }   
   else {
      envCounter++;
   }

   if (envCounter > 2) {
      print $3;
   }
   else {
      print repo, $3, "from", $2,"will not be deleted" > "/dev/stderr"
   }

} '  $IMAGES > $IMAGETAGS


# Allow the user to abort the delete

imageCount=$(wc -l $IMAGES)
tagCount=$(wc -l $IMAGETAGS)

echo
echo "-----------------------------------------------------"
echo "Deleting $tagCount images out of $imageCount"
echo "Filtering $FILTER"
echo "-----------------------------------------------------"


if [ $dryRun = "false" ]; then
    echo "Press Enter to Continue or abort with CTRL-C"
    read kk
fi

cat $IMAGETAGS | egrep -v $FILTER | while read TAG
do
   echo "Deleting $REPO $TAG"
   if [ $dryRun = "false" ]; then
        aws ecr batch-delete-image --image-ids imageTag=$TAG  --repository-name $REPO 
   fi
done

rm -rf $IMAGES $IMAGETAGS
