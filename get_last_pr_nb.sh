FRONT_TAGS=$(gcloud container images list-tags europe-west1-docker.pkg.dev/z-devsecops-cloud/z-devsecops-registry/frontend --format='value(tags)')
i=0
last_tow_images=()
for tag in $FRONT_TAGS; do \
    last_tow_images+=($tag)
    i=$((i+1))
    if [ $i -eq 2 ]
    then
        echo export LAST_PR_NB=$tag
        break
    fi
done