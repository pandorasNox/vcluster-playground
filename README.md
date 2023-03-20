
## use-cases (practical)
- bitnami rabbitmq chart
  - bitnami rabbit mq wants to create role binding needs more permissions than regular namespace has, rabbit mq k8s uses a plugin, this plugin uses k8s events, events are not namespacesed or smth like that
    - so privilaged cluster admin was necessary

## cmds
``` bash
vcluster --namespace lab-vcluster create --connect=false vcluster-test
# automaticly installs helm if not present (v )

vcluster --namespace lab-vcluster connect vcluster-test -- ash

## in normal cli container
# kubectl -n lab-vcluster get secret vc-test --template={{.data.config}} | base64 -d > vkubeconfig.yaml
# kubectl -n lab-vcluster port-forward test-0 8443 &
# kubectl --kubeconfig=./vkubeconfig.yaml get ns

```

## concept in a pipeline

- fixed name
- create vcluster
- create ingress
- extract kubeconfig (into s3) ???

## open questions

- support service accounts for multiple users?
  - beeing able to recreate vcluster with same secrets???

