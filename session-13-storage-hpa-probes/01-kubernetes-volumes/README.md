# Session 13 — Task 1: Kubernetes Volumes

Notes on the volume types covered, with examples from `01-volumes/` and
`02-persistent-storage/`.

## emptyDir

- Empty directory created when the Pod is **assigned to a node**; lives as
  long as the Pod does.
- Deleted when the Pod dies — good for scratch space, caches, sharing files
  between containers in the same Pod.
- Example: `01-volumes/emptydir-pod.yaml`

```yaml
volumes:
  - name: scratch
    emptyDir: {}
```

## hostPath

- Mounts a file/dir **from the node's filesystem** into the Pod.
- Data survives the Pod but is tied to that node — dangerous for
  multi-node portability and a security risk (exposes the host).
- Example: `01-volumes/hostpath-pod.yaml`

```yaml
volumes:
  - name: host-data
    hostPath:
      path: /data
      type: DirectoryOrCreate
```

## PersistentVolume (PV)

- A piece of storage **in the cluster**, provisioned by an admin or
  dynamically by a StorageClass. Has a lifecycle independent of Pods.
- Key fields: `capacity`, `accessModes` (RWO/ROX/RWX), `persistentVolumeReclaimPolicy`.
- Example: `02-persistent-storage/pv.yaml`

## PersistentVolumeClaim (PVC)

- A **request** for storage by a user/Pod — size + access mode. Kubernetes
  binds it to a matching PV, then Pods mount the PVC by name.
- Example: `02-persistent-storage/pvc.yaml` + `pod.yaml`

```yaml
volumes:
  - name: data
    persistentVolumeClaim:
      claimName: my-pvc
```

## StorageClass

- Describes "classes" of storage (fast SSD, standard, etc.) and **which
  provisioner** creates volumes (`provisioner`, `parameters`, `reclaimPolicy`).
- Example: `03-storageclass/pvc.yaml`

```bash
kubectl get storageclass
```

## Dynamic provisioning

- PVC references a StorageClass → the provisioner creates a real disk + PV
  automatically → bound to the claim. No admin-pre-created PV needed.

```text
PVC ──▶ StorageClass ──▶ provisioner creates disk ──▶ PV ──▶ bound ──▶ Pod mounts PVC
```

Verify:

```bash
kubectl get pv,pvc          # PVC shows STATUS Bound, PV shows the claim
kubectl describe pvc <pvc>  # ProvisioningSucceeded events
```
