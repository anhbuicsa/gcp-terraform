# Audit and notify when an user modify the important files
Tracking File Server configuration changes is important as these changes can lead to critical services outage. IT security in charge, therefore, must track changes of files to know who changed the configuration and when. You can easily do it by enabling auditd and configure the watched files. After you have enabled change audit, you configure the ops agent to send the log to stackdriver. After done with above step you can view and investigate all the changes in Stackdriver as well as recieve the notification.

![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/alert-modify-file/images/hacker.png?raw=true "Title")
#### Further details: [alert modify file](https://github.com/anhbuicsa/gcp-terraform/tree/master/alert-modify-file)


# gcp-tf-temp

Traditionally terraform used json key as the below. Applications and users can authenticate as a service account using generated service account keys. 
```
provider "google" {
 credentials = file("google-service-account.json")
 project = "playground-project-id"
 region = "asia-east1”
}
```
#### Further details: [gcp tf impersonate](https://github.com/anhbuicsa/gcp-terraform/tree/master/gcp-tf-impersonate)