---
name: nomad-jobs
description: Author new Nomad v1.11.2 HCL job specs, review and validate existing specs, and convert Docker Compose files to Nomad HCL — service, batch, and periodic/cron jobs using the docker task driver only
license: MIT
compatibility: opencode
---

## Nomad jobs skill

Apply these rules whenever authoring, reviewing, or converting Nomad job specifications.

### Constraints

- **Nomad version:** v1.11.2 only. Do not use fields, stanzas, or behaviours introduced in later versions.
- **Format:** HCL only. Never produce JSON job specs.
- **Task driver:** `docker` only. Never use `exec`, `raw_exec`, `java`, or any other driver.
- **Job types:** `service` and `batch` only, including periodic variants. Do not generate `system` or `sysbatch` jobs unless the user explicitly requests it.

---

### Authoring new job specs

When asked to create a new Nomad job spec:

1. Always include the top-level required fields: `job`, `datacenters`, `type`.
2. For `service` jobs: include at minimum one `group` with a `task`, a `network` stanza, and a `service` stanza with a health check.
3. For `batch` jobs: set `type = "batch"`. Include a `restart` stanza with `attempts = 0` and `mode = "fail"` unless the user specifies otherwise.
4. For periodic/cron jobs: add a `periodic` stanza with `cron`, `prohibit_overlap = true`, and `time_zone = "UTC"` unless the user specifies a timezone. Set the job `type` to `"batch"` for periodic batch jobs.
5. Always set resource limits explicitly: `cpu`, `memory` in the `resources` stanza. Never rely on defaults.
6. For the `docker` driver, always include:
   - `image` in `config`
   - `force_pull = true` unless the user specifies otherwise
   - `auth` block if the image is from a private registry (prompt the user for credentials handling strategy)
7. Use `template` stanzas with `env = true` for environment variable injection from Consul or Vault where appropriate.
8. Output the complete job spec. Never truncate or use placeholder comments like `# ... rest of config`.

---

### Reviewing and validating existing job specs

When asked to review or validate an existing HCL job spec:

1. Check for **correctness**: missing required fields, invalid field values for Nomad v1.11.2, and deprecated stanzas.
2. Check for **safety**: missing resource limits, missing health checks on service jobs, `force_pull = false` on docker tasks without a pinned digest, missing `restart` or `reschedule` policies.
3. Check for **best practices**: overly broad `datacenters` wildcards, missing `update` stanza on service jobs, missing `vault` or `template` stanzas where secrets appear hardcoded in `env`.
4. Structure your review as a list of findings, each with:
   - **Severity:** `error` (will fail validation or cause runtime failure), `warning` (risky but valid), or `suggestion` (improvement only)
   - **Location:** the stanza path (e.g. `job > group "web" > task "app" > config`)
   - **Description:** what the issue is and why it matters
   - **Fix:** the corrected HCL snippet
5. End the review with a summary of counts: `X error(s), Y warning(s), Z suggestion(s)`.
6. Remind the user to run `nomad job validate <file>` before deploying.

---

### Converting Docker Compose to Nomad HCL

When asked to convert a `docker-compose.yml` to Nomad HCL:

1. Map each top-level `services` entry to a separate Nomad `group` within a single job, unless the user requests separate job files per service.
2. Apply these mappings:

   | Docker Compose field | Nomad HCL equivalent |
   |---|---|
   | `image` | `config { image = "..." }` |
   | `ports` | `network { port "label" { to = <container_port> } }` + `service { port = "label" }` |
   | `environment` | `env { ... }` block on the task |
   | `volumes` (host-bind) | `config { volumes = ["host:container"] }` |
   | `command` / `entrypoint` | `config { command = "..." args = [...] }` |
   | `labels` | `meta { ... }` on the group |
   | `restart: always` | `restart { attempts = 10 mode = "delay" }` |
   | `restart: no` | `restart { attempts = 0 mode = "fail" }` |
   | `healthcheck` | `service { check { ... } }` stanza |
   | `mem_limit` | `resources { memory = <MiB> }` |
   | `cpus` | `resources { cpu = <MHz> }` (note: Nomad uses MHz, not fractional CPUs — state the assumed MHz value and ask the user to confirm) |

3. For any Docker Compose key not in the table above and not mappable to Nomad HCL, explicitly list it in an **Unmapped fields** section at the end of the output:
   - Field name and value
   - Reason it cannot be mapped
   - Suggested manual remediation if one exists
4. Always output the complete converted HCL. Never truncate.
5. Remind the user to run `nomad job validate <file>` on the output before deploying.
