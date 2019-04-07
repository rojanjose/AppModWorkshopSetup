# Scripts to provision IKS workshop environment.

## Script help

Help for each script can be found by calling them with the ```-h``` or ```--help``` flags. Here is a brief listing of each:


inviteUsers.sh:
```text
Usage: ./inviteUsers.sh [OPTIONS]...

Invite users to join account

Mandatory arguments to long options are mandatory for short options too.
  -u=,  --user-list=FILE      FILE where users email addresses are stored;
                                  defaults to email.txt
  -h   --help                 display this help and exit
```


addAccessGroup.sh:
```text
Usage: ./addAccessGroup.sh [OPTIONS]...

Add users from a file to an access group.

Mandatory arguments to long options are mandatory for short options too.
  -g=, --access-group=STRING       add users to STRING access group
                                       defaults to App-Mod
  -u=,  --user-list=FILE           FILE where users email addresses are stored;
                                       defaults to email.txt
  -h   --help                      display this help and exit
```


createClusters.sh:
```text
Usage: ./createClusters.sh [OPTIONS]...

Create clusters.

Mandatory arguments to long options are mandatory for short options too.
  -r=,  --cluster-range=NUM1-NUM2    range from NUM1 to NUM2 for cluster numbers
  -hw=, --hardware=STRING            hardware configuration for k8s;
                                         defaults to shared
      --kube-version=NUM             k8s version to install;
                                         defaults to 1.12.6
  -t=,  --machine-type=STRING        STRING machine configuration;
                                         defaults to u2c.2x4
      --private-vlan=NUM             use private vlan identified by NUM;
                                         defaults to 2573695
      --public-vlan=NUM              use public vlan identified by NUM;
                                         defaults to 2573693
  -c=,  --worker-node-count=NUM      NUM workers in cluster;
                                         defaults to 2
  -z=,  --zone=STRING                host clusters in STRING availabilty zone;
                                         defaults to wdc07
  -h   --help                        display this help and exit
```


configureClusters.sh:
```text
Usage: ./configureClusters.sh [OPTIONS]...

Configure Clusters.

Mandatory arguments to long options are mandatory for short options too.
  -r=,  --cluster-range=NUM1-NUM2    range from NUM1 to NUM2 for cluster numbers;
                                         defaults to 1-50
  -h   --help                        display this help and exit
```


validateClusters.sh
```text
Usage: ./validateClusters.sh -r=1-10
```


deleteClusters.sh:
```
Usage: ./deleteClusters.sh [OPTIONS]...

Delete Clusters.

Mandatory arguments to long options are mandatory for short options too.
  -r=,  --cluster-range=NUM1-NUM2    range from NUM1 to NUM2 for cluster numbers;
  -h   --help                        display this help and exit
```


removeUsers.sh:
```text
Usage: ./removeUsers.sh [OPTIONS]...

Remove users from account

Mandatory arguments to long options are mandatory for short options too.
  -u=,  --user-list=FILE      FILE where users email addresses are stored;
                                  defaults to email.txt
  -h   --help                 display this help and exit
```

