# authorizer

## Introduction
This chart bootstraps an instance of the [Authorizer](https://authorizer-tech.github.io) platform on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Pre-requisites
- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart
To install the chart with the release name `authorizer`:

```console
$ helm repo add authorizer-tech https://authorizer-tech.github.io/helm-charts/
$ helm install authorizer authorizer-tech/authorizer
```

The command deploys an installation of the Authorizer platform on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `authorizer` release:

```console
$ helm delete authorizer
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### access-watcher

#### Image parameters
| Name                      | Description                                            | Default Value                     |
|---------------------------|--------------------------------------------------------|-----------------------------------|
| watcher.image.registry    | Container image registry                               | gcr.io                            |
| watcher.image.repository  | Container image repository                             | authorizer-tech/access-watcher    |
| watcher.image.tag         | Container image tag (immutable tags are recommended)   | v0.0.1                            |
| watcher.image.pullPolicy  | Container image pull policy                            | IfNotPresent                      |
| watcher.image.pullSecrets | Pull secrets for the image registry                    | []                                |

#### Deployment parameters
| Name           | Description                         | Default Value |
|----------------|-------------------------------------|---------------|
| watcher.podLabels      | Labels for access-watcher pods      | {}            |
| watcher.podAnnotations | Annotations for access-watcher pods | {}            |
| watcher.podSecurityContext | Set the pods' security context | {}            |
| watcher.resources.limits | The resource limits for the access-watcher container | {} |
| watcher.resources.requests | The requested resources for the access-watcher container | {} |
| watcher.affinity | Affinity for pod assignment | {} |
| watcher.tolerations | Tolerations for pod assignment | [] |
| watcher.nodeSelector | Node labels for pod assignment | {} |

#### App config parameters
| Name                | Description                                                    | Default Value |
|---------------------|----------------------------------------------------------------|---------------|
| watcher.grpcGateway.enabled | Enable HTTP/JSON to gRPC transcoding and serve the HTTP server | false         |

#### Other parameters
| Name                | Description                                              | Default Value |
|---------------------|----------------------------------------------------------|---------------|
| watcher.enabled | Enable or disable the access-watcher deployment | true |
| watcher.autoscaling.enabled | Enable Horizontal POD autoscaling for the access-watcher | false         |
| watcher.autoscaling.minReplicas | Minimum number of access-watcher replicas | 1         |
| watcher.autoscaling.maxReplicas | Maximum number of access-watcher replicas | 10         |
| watcher.autoscaling.targetCPU | Target CPU utilization percentage | 65 |
| watcher.autoscaling.targetMemory | Target memory utilization percentage | 65 |

### access-controller
The `access-controller` is installed as a subchart with default [values](../access-controller/values.yaml). See the [access-controller parameters](../access-controller/README.md#parameters) for more information on how to configure it.

----

Specify each parameter using the --set key=value[,key=value] argument to helm install. For example,

```console
helm install authorizer \
  --set watcher.grpcGateway.enabled=true \
  --set access-controller.cockroachdb.auth.password=secretpassword \
    authorizer-tech/authorizer
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install authorizer -f values.yaml authorizer-tech/authorizer
```

> **Tip**: You can use the default [values.yaml](./values.yaml)

For more information on how to set the values of a subchart in Helm, please take a look at the official Helm doc on [Subcharts and Global Values](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/).

## Configuration and Installation Details

> We strive to follow the same principles as Bitnami with regards to [Rolling vs Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

We will release a new chart and update its container image tags if a new version of the main container is released or critical vulnerabilities exist.
