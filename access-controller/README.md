# access-controller

## Introduction
This chart bootstraps an [access-controller](https://github.com/authorizer-tech/access-controller) statefulset on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [official CockroachDB chart](https://github.com/cockroachdb/helm-charts/tree/master/cockroachdb) which is required for bootstrapping a CockroachDB deployment to fullfil the database requirements of the access-controller.

## Pre-requisites
- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart
To install the chart with the release name `access-controller`:

```console
$ helm repo add authorizer-tech https://authorizer-tech.github.io/helm-charts/
$ helm install access-controller authorizer-tech/access-controller
```

The command deploys the access-controller on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `access-controller` deployment:

```console
$ helm delete access-controller
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Image parameters

| Name              | Description                                            | Default Value                     |
|-------------------|--------------------------------------------------------|-----------------------------------|
| image.registry    | Container image registry                               | gcr.io                            |
| image.repository  | Container image repository                             | authorizer-tech/access-controller |
| image.tag         | Container image tag (immutable tags are recommended)   | v0.1.2                            |
| image.pullPolicy  | Container image pull policy                            | IfNotPresent                      |
| image.pullSecrets | Pull secrets for the image registry                    | []                                |

### App config parameters

| Name                | Description                                                                                                                                                                                                       | Default Value |
|---------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| grpcGateway.enabled | Enable HTTP/JSON to gRPC transcoding and serve the HTTP server                                                                                                                                                    | false         |
| conf.join           | A list of existing nodes to join this node to<br><br>Each item in the array should be a FQDN (and port if needed) resolvable by new pods<br><br>NOTE: This forms a cluster between this node and those specified | []            |

### Database parameters

| Name                            | Description                                                                                                                                                                                                       | Default Value |
|---------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| cockroachdb.enabled             | Deploy a CockroachDB database to satisfy the applications database requirements<br><br>To use an externally provisioned CockroachDB database set this to false and configure the `externalDatabase.*` parameters | true          |
| cockroachdb.auth.username       | The database username                                                                                                                                                                                             | admin         |
| cockroachdb.auth.password       | The database password for the user                                                                                                                                                                                | ""            |
| externalDatabase.host           | The hostname of the database                                                                                                                                                                                      | localhost     |
| externalDatabase.port           | The port the database is exposed on                                                                                                                                                                               | 26257         |
| externalDatabase.username       | The database username                                                                                                                                                                                             | admin         |
| externalDatabase.password       | The database password for the user                                                                                                                                                                                | ""            |
| externalDatabase.database       | The database name                                                                                                                                                                                                 | postgres      |
| externalDatabase.existingSecret | The name of an existing secret with database credentials<br><br>NOTE: Must contain key `cockroachdb-password`<br>NOTE: When this is set, the `externalDatabase.password` parameter is ignored                     | nil           |

### Other parameters


Specify each parameter using the --set key=value[,key=value] argument to helm install. For example,

```console
helm install access-controller \
  --set grpcGateway.enabled=true \
  --set cockroachdb.auth.password=secretpassword \
    authorizer/access-controller
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install access-controller -f values.yaml authorizer/access-controller
```

> **Tip**: You can use the default [values.yaml](./values.yaml)

## Configuration and Installation Details

> We strive to follow the same principles as Bitnami with regards to [Rolling vs Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

We will release a new chart and update its container image tags if a new version of the main container is released or critical vulnerabilities exist.

### External database support
You may want to have the access-controller connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [externalDatabase parameter](#database-parameters). You should also disable the CockroachDB installation with the cockroachdb.enabled option. Here is an example:

```console
cockroachdb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.username=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=26257
```
