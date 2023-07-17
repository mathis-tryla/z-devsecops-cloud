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
```
mvn -B --update-snapshots package --file ${{ env.BACKEND }}/pom.xml
```

#### 3) Google Cloud authentication

```
gcloud artifacts repositories set-cleanup-policies projects/z-devsecops-cloud/locations/europe-west1/repositories/z-devsecops-registry --project=z-devsecops-cloud --location=europe-west1 --policy=cleanup-policy.json
```

### How does the CD work ?



### How to monitor our cluster ?
The final step of the project was to setup a monitoring system so we can get metrics from our Kubernetes cluster. We chose to query data with Prometheus in order to display them into Grafana dashboards. Once connected to the k8s cluster, you can get access to the dashboards with the following commands :

##### Query Trivy Operator metrics in Prometheus
```sh
kubens monitoring
kubectl port-forward pod/prometheus 9090
```
Then navigate to http://localhost:9090/graph and you can retrieve some security information by typing the following linees to the input query:
Total vulnerabilities found in our cluster
```sh
sum(trivy_image_vulnerabilities)
```
Total misconfiguration identified in your cluster
```sh
sum(trivy_resource_configaudits)
```

##### Set up Grafana dashboard for Trivy Operator metrics
```sh
kubens monitoring
kubectl port-forward service/prom-grafana 3000:80
```
Then navigate to http://localhost:3000, click on "Dashboards" -> "Browse" -> "New" -> "Import" -> paste the ID of the Aqua Trivy Dashboard: 17813.
Once pasted, you should see the Trivy Operator Dashboard as part of your Dashboard list.