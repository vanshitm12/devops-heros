# Session 11 — Task 2: Kubernetes Object Comparison

## Deployment vs ReplicaSet

| | Deployment | ReplicaSet |
| :--- | :--- | :--- |
| Purpose | Declarative updates for Pods; the object you normally manage | Ensures a fixed number of identical Pod replicas run |
| Pod management | Creates/owns ReplicaSets, which own the Pods | Owns Pods directly via label selectors |
| Scaling | `kubectl scale deploy/...` (scales the underlying RS) | `kubectl scale rs/...` possible but rarely done directly |
| Rolling updates | Built-in: `strategy`, `maxSurge`, `maxUnavailable`, `rollout undo` | No rollout logic — replaces Pods only when told to |
| Relationship | A Deployment creates a **new ReplicaSet per revision** and scales old ones down; old RSs are kept for rollback | ReplicaSet is the mechanism; Deployment is the policy on top |

## Deployment vs DaemonSet vs StatefulSet

| | Deployment | DaemonSet | StatefulSet |
| :--- | :--- | :--- | :--- |
| Use case | Stateless apps (APIs, frontends) | One Pod per node (log agents, monitoring, kube-proxy) | Stateful apps (databases, Kafka) |
| Pod creation | Replicas placed anywhere the scheduler picks | Exactly one Pod on every (matching) node | Ordered creation: `pod-0`, `pod-1`, ... stable names |
| Scaling | `replicas: N` | Scales with node count automatically | `replicas: N`, scaled up/down in order |
| Networking | Pods interchangeable, behind a Service | Usually hostNetwork/hostPort or per-node | Stable DNS per Pod via a headless Service |
| Storage | Shared or ephemeral volumes | Usually mounts host paths | Per-Pod PersistentVolumeClaim via `volumeClaimTemplates` |
| Example | nginx frontend | fluentd log collector | MySQL/PostgreSQL cluster |

## ReplicaSet vs Service

- **ReplicaSet responsibility:** keeps the desired count of healthy Pod
  replicas alive — recreates Pods that die.
- **Service responsibility:** gives a stable virtual IP + DNS name and
  load-balances traffic to whatever Pods currently match its selector.
- **Why a Service is required:** Pod IPs are ephemeral — a ReplicaSet replaces
  Pods with new IPs, so clients can't hardcode them. The Service abstracts the
  churn.
- **How traffic reaches Pods:** `Service.spec.selector` matches Pod labels →
  the control plane maintains an **Endpoints/EndpointSlice** list of matching
  Pod IPs → kube-proxy (iptables/IPVS) forwards `ClusterIP:port` traffic to a
  healthy Pod's `targetPort`.
