# z-devsecops-cloud
Zenika Lille Mathis stage

![eph](https://github.com/mathis-tryla/z-devsecops-cloud/actions/workflows/build-push-eph.yml/badge.svg)
![prod](https://github.com/mathis-tryla/z-devsecops-cloud/actions/workflows/push-prod.yml/badge.svg)

## CI/CD

The project is tested, compiled and deployed through a CI/CD pipeline implemented on Github Actions.

### How does the CI work ?

Once a Pull Request is opened or synchronized, the *build-and-push-eph* job is launched.
Here is what this job is composed of.

#### 1) SAST with Snyk
The first step of the *build-and-push-eph* job is scanning the vulnerabilities from the code source with an open-source Static Application Security Testing (SAST) tool called **Snyk**. First from the frontend folder, then from the backend one. Then we upload the sarif-formated results of scanning to our repository's Github Security tab in order to get a user-friendly view of all of the scanned vulnerabilities, as below :

```
![Github Security tab](/Users/zenika/Desktop/Capture d’écran 2023-07-11 à 11.07.17.png?raw=true "Github Security tab preview")
```

> **Note**: you have to make your repository public so you can upload your sarif files to Github Security tab

In each of Snyk-detected vulnerabilities, you'll see following informations about it:
- name
- source file
- ID weekness
- overview
- remediation


#### 2) Java build
The next step is to specify the **Java** version you want to run your app on and building the application with **Maven**:
```sh
mvn -B --update-snapshots package --file ${{ env.BACKEND }}/pom.xml
```


#### 3) Create a Google Artifact Registry repository
As our application will be containerized with Docker, we have to store our images in a Google Artifact Registry repository.
One folder is dedicated to frontend images and another for backend ones.
We store the link of the Google Artifact Registry repository in the `env.ARTIFACT_REGISTRY` variable.


#### 4) Google Cloud authentication
Before building our Docker images, we have to authenticate us to Google Cloud through the workload identity federation, by specifying the workload identity provider and the service account.
Then we configure Docker to use the gcloud command-line tool as a credential, and get the GKE credentials so we can carry out actions on our k8s cluster later.
> **Note**: see https://github.com/marketplace/actions/authenticate-to-google-cloud#setup to set up the workload identity federation provided by Google Cloud


#### 5) Build Docker images
We can now build our Docker frontend and backend images, with the following commands:
```sh
docker build \
-t "${{ env.ARTIFACT_REGISTRY }}/frontend:pr-${{ env.PR_NUMBER }}" \
${{ env.FRONTEND }}
```
```sh
docker build \
-t "${{ env.ARTIFACT_REGISTRY }}/frontend:pr-${{ env.PR_NUMBER }}" \
${{ env.BACKEND }}
```

Both images will be stored in the artifact registry repository that we've created during the previous part.


#### 6) Container images vulnerability scanner with Trivy
Once our Docker images are built, we can scan them with Trivy, so we can upload vulnerabilities to GitHub Security Tab of our repository.
The scans' outputs will be stored in a sarif-formatted file.  


#### 7) Publish Docker images to Google Artifact Registry
When the previous scans are done, we push both Docker images to our Google Artifact Registry repository,
with the following commands:
```sh
docker push ${{ env.ARTIFACT_REGISTRY }}/frontend --all-tags
docker push ${{ env.ARTIFACT_REGISTRY }}/backend --all-tags
```


#### 8) Sign images with Google Key Management Service key
Thanks to Cosign and Google KMS we sign our images, so we can prove the integrity and the trust-worthy source of the images,
with the following commands:
````sh
cosign sign --yes --key ${{ env.KMS }} ${{ env.ARTIFACT_REGISTRY }}/frontend:pr-${{ env.PR_NUMBER }}
cosign sign --yes --key ${{ env.KMS }} ${{ env.ARTIFACT_REGISTRY }}/backend:pr-${{ env.PR_NUMBER }}
````

The `env.KMS` variable is formatted like:
`gcpkms://projects/<gcp_project_name>/locations/<location>>/keyRings/<keyRing_name>/cryptoKeys/<cryptoKeys_name>` 

>**Note**: pr-`${{ env.PR_NUMBER }}` tag means that it is an ephemeral image used to deploy an ephemeral environment.


#### 9) Deploy Docker images to the GKE Cluster
Finally, we deploy our ephemeral environment supporting our application based on the ephemeral Docker images signed previously, using Kubernetes.
Here are the steps to perform this:
1) Create an ephemeral namespace named `pr-${{ env.PR_NUMBER }}`
2) Create the frontend deployment with the `pr-${{ env.PR_NUMBER }}` tagged frontend image in the ephemeral namespace
3) Create the backend deployment with the `pr-${{ env.PR_NUMBER }}` tagged backend image in the ephemeral namespace
4) Create the API service in the ephemeral namespace
5) Create the frontend service in the ephemeral namespace
6) Create the ingress in the ephemeral namespace, so we can expose our app


#### 10) DAST with OWASP ZAP
The previous step generated a http url making our application externally accessible.
Now we pass this url in a DAST (Dynamic Application Security Testing) tool called OWASP ZAP.
This tool will perform penetration testing on our application and generate a markdown file.
The content of this file will be pasted as a comment of our Pull Request.


### How does the CD work ?
Once a Pull Request is merged to `main` branch, the *push-prod* job is launched. Here is what this job is composed of.

#### 1) Google Cloud authentication
Before building our Docker images, we have to authenticate us to Google Cloud through the workload identity federation, by specifying the workload identity provider and the service account.
Then we configure Docker to use the gcloud command-line tool as a credential, and get the GKE credentials so we can carry out actions on our k8s cluster later.
> **Note**: see https://github.com/marketplace/actions/authenticate-to-google-cloud#setup to set up the workload identity federation provided by Google Cloud


#### 2) Tagging frontend and backend images
Before publishing Docker images to our Google Artifact Registry repository, we tag our images with the Maven verssion that we have incremented during step 4 of the *How does the CI work?* part, using the following commands:
```sh
docker tag \
${{ env.ARTIFACT_REGISTRY }}/frontend:$LAST_PR_NB \
${{ env.ARTIFACT_REGISTRY }}/backend:$MVN_VERSION 
```


#### 3) Publish Docker images to Google Artifact Registry
When the previous images are tagged, we push both Docker images to our Google Artifact Registry repository,
with the following commands:
```sh
docker push ${{ env.ARTIFACT_REGISTRY }}/frontend:$MVN_VERSION
docker push ${{ env.ARTIFACT_REGISTRY }}/backend:$MVN_VERSION
```


#### 4) Sign images with Google Key Management Service key
Thanks to Cosign and Google KMS we sign our images, so we can prove the integrity and the trust-worthy source of the images,
with the following commands:
````sh
cosign sign --yes --key ${{ env.KMS }} ${{ env.ARTIFACT_REGISTRY }}/frontend:$MVN_VERSION
cosign sign --yes --key ${{ env.KMS }} ${{ env.ARTIFACT_REGISTRY }}/backend:$MVN_VERSION
````

The `env.KMS` variable is formatted like:
`gcpkms://projects/<gcp_project_name>/locations/<location>>/keyRings/<keyRing_name>/cryptoKeys/<cryptoKeys_name>`

>**Note**: `$MVN_VERSION` tag means that it is a production-tagged image used to update the production environment.


#### 5) Deploy Docker images to the GKE Cluster
Finally, we deploy our ephemeral environment supporting our application based on the ephemeral Docker images signed previously, using Kubernetes.
Here are the steps to perform this:
1) Create a production namespace named `env-intern` if it doesn't already exist
2) Update the `$MVN_VERSION` so we can deploy the latest prod-tagged images 
3) Create the frontend deployment with the `$MVN_VERSION` tagged frontend image in the production namespace
4) Create the backend deployment with the `$MVN_VERSION` tagged backend image in the production namespace
5) Create the API service in the production namespace
6) Create the frontend service in the production namespace
7) Create the ingress in the production namespace, so we can expose our app


#### 6) DAST with OWASP ZAP
The previous step generated a http url making our application externally accessible.
Now we pass this url in a DAST (Dynamic Application Security Testing) tool called OWASP ZAP.
This tool will perform penetration testing on our application and generate a markdown file.
The content of this file will be pasted as a comment of our Pull Request.




## Setting clean-up policies
Google Cloud Platform allows us to clean Google Artifact Registry images as to conditions that we have to define in a JSON file.
As part of our project, we decide to :
1) Delete pr-tagged images older than 30 days
2) Keep images sha256-prefixed images newer than 10 days

In order to apply these policies, we run this command:
```
gcloud artifacts repositories set-cleanup-policies \
projects/<project_name>/locations/<location>/repositories/<repository> \
--project=<project_name> --location=<location> \
--policy=<cleanup-policy-file_path>
```


## Monitoring
The final step of the project was to set up a monitoring system, so we can get metrics from our Kubernetes cluster. We chose to query data with Prometheus in order to display them into Grafana dashboards. Once connected to the k8s cluster, you can get access to the dashboards with the following commands :

### Query Trivy Operator metrics in Prometheus
```sh
kubens monitoring
kubectl port-forward pod/prometheus 9090
```
Then navigate to http://localhost:9090/graph, and you can retrieve some security information by typing the following linees to the input query:
##### Total vulnerabilities found in our cluster
```sh
sum(trivy_image_vulnerabilities)
```
##### Total misconfiguration identified in your cluster
```sh
sum(trivy_resource_configaudits)
```

### Set up Grafana dashboard for Trivy Operator metrics
```sh
kubens monitoring
kubectl port-forward service/prom-grafana 3000:80
```
Then navigate to http://localhost:3000, click on "Dashboards" -> "Browse" -> "New" -> "Import" -> paste the ID of the Aqua Trivy Dashboard: 17813.
Once pasted, you should see the Trivy Operator Dashboard as part of your Dashboard list.