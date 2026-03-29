# Environment Standard Operating Procedures (SOP)

**Feature:** `<feature-id>.<title>`  
**Last Updated:** `<date>`  
**Status:** `draft | active | deprecated`

---

## Overview

This document defines the environment configuration, naming conventions, and tool access rules for this feature's development, testing, and deployment. All agents working on this feature must follow these conventions to ensure consistency and avoid service confusion.

---

## Service Naming Conventions

### Container Names

All containers for this feature must follow this naming pattern:

```
<feature-id>-<service-name>-<tier>
```

**Format breakdown:**
- `<feature-id>`: Beads issue ID (e.g., `pft`, `umk`, `3mu`)
- `<service-name>`: Logical service (e.g., `db`, `api`, `cache`, `queue`)
- `<tier>`: Environment tier (e.g., `dev`, `test`, `staging`, `prod`)

**Examples:**
- `pft-db-dev` — PostgreSQL for MrSmith-pft development
- `umk-api-test` — API service for MrSmith-umk testing
- `3mu-cache-staging` — Redis cache for MrSmith-3mu staging

### Environment Variables

All environment variables must be prefixed with the feature ID in UPPERCASE:

```
<FEATURE_ID>_<SERVICE>_<SETTING>
```

**Examples:**
- `PFT_DB_HOST=pft-db-dev`
- `PFT_DB_PORT=5432`
- `PFT_API_PORT=8080`
- `UMK_CACHE_REDIS_URL=redis://umk-cache-test:6379`

### Network Aliases

Define service endpoints using this pattern (for Docker Compose / Kubernetes):

```
<service-name>.<feature-id>.internal
```

**Examples:**
- `db.pft.internal` — PostgreSQL for feature pft
- `api.umk.internal` — API for feature umk
- `cache.3mu.internal` — Cache for feature 3mu

---

## Database Access Rules

### Rule: Use containers, not host tools

**❌ Forbidden:**
```bash
psql -h localhost -U postgres  # Never run on host
mysql -h 127.0.0.1 -u root     # Never run on host
```

**✅ Correct:**
```bash
# Connect via container
docker exec pft-db-dev psql -U postgres

# Or use a database client container
docker run --network pft-network \
  -it postgres:latest psql \
  -h db.pft.internal -U postgres
```

### Connection String Format

When specifying database connections in code/config, use this format:

```
postgresql://user:password@<service-name>.<feature-id>.internal:5432/dbname
postgresql://user:password@pft-db-dev:5432/dbname
```

**For Docker Compose:**
- Internal service name: `pft-db-dev` (resolves via Docker DNS)
- External port (if needed): `5432` (host mapping)

**For Kubernetes:**
- Internal DNS: `pft-db-dev.<namespace>.svc.cluster.local`

### Credential Storage

**❌ Never commit credentials:**
- No `.env` with real passwords in Git
- No hardcoded secrets in source code

**✅ Correct approach:**
1. Store secrets in `.env.local` (gitignored)
2. Load at runtime from environment or secret management tool
3. For Docker: Use `--env-file .env.local` or `secrets:` in compose
4. Document required variables in this SOP (names only, not values)

---

## Networking & Port Mappings

### Port Allocation Strategy

Reserve port ranges per feature to avoid conflicts:

| Feature | Base Port | Range | Services |
|---------|-----------|-------|----------|
| pft | 5400 | 5400–5499 | DB, migrations, tools |
| umk | 5500 | 5500–5599 | DB, API, cache |
| 3mu | 5600 | 5600–5699 | API, queue, workers |

### Per-Service Port Assignment

**pft feature example:**

| Service | Internal Port | External Port | Purpose |
|---------|---------------|---------------|---------|
| PostgreSQL | 5432 | 5400 | Database |
| PgAdmin | 5050 | 5401 | DB admin UI |
| API | 8080 | 5402 | REST API |
| Webhook | 3000 | 5403 | Event receiver |

**Docker Compose syntax:**
```yaml
services:
  pft-db-dev:
    ports:
      - "5400:5432"  # external:internal
    environment:
      - PFT_DB_PORT=5432
```

**Access patterns:**
- **From host:** `localhost:5400` (external port)
- **From another container:** `pft-db-dev:5432` (service name + internal port)
- **From code inside container:** `pft-db-dev:5432` (internal)

---

## Logging & Debugging

### Log File Locations

Centralize logs in a per-feature directory:

```
logs/
├── pft/
│   ├── db.log          # Database logs
│   ├── api.log         # API service logs
│   ├── cache.log       # Cache logs
│   └── debug.log       # Debug output
├── umk/
│   └── ...
└── 3mu/
    └── ...
```

### Accessing Logs

**From Docker container:**
```bash
# Follow logs from service
docker logs -f pft-db-dev

# From compose
docker-compose -f docker-compose.pft.yml logs -f db
```

**From mounted volume:**
```bash
# Logs are written to ./logs/pft/
tail -f logs/pft/db.log
tail -f logs/pft/api.log
```

### Debug Mode

Enable debug logging by setting:
```bash
export <FEATURE_ID>_DEBUG=true
export PFT_DEBUG=true
```

---

## Secrets & Credentials

### Required Environment Variables

These must be set before running this feature (values NOT shown here):

| Variable | Service | Purpose | Default | Required |
|----------|---------|---------|---------|----------|
| `PFT_DB_USER` | PostgreSQL | Database user | — | ✅ yes |
| `PFT_DB_PASSWORD` | PostgreSQL | Database password | — | ✅ yes |
| `PFT_API_SECRET` | API | Signing key | — | ✅ yes |
| `PFT_LOG_LEVEL` | All | Logging verbosity | `info` | ❌ no |

### Loading Secrets

**Option 1: Local .env file (gitignored)**
```bash
# .env.local
PFT_DB_USER=dev
PFT_DB_PASSWORD=dev-password-123
PFT_API_SECRET=dev-secret-key
```

**Option 2: Docker secrets (production-like)**
```bash
# Mount at runtime
docker run \
  --env-file .env.local \
  pft-api:latest
```

**Option 3: Kubernetes secrets**
```yaml
# In k8s manifest
env:
  - name: PFT_DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: pft-secrets
        key: db-password
```

---

## Data Persistence

### Volume Mounting

All stateful services must use named volumes or host mounts:

```yaml
services:
  pft-db-dev:
    volumes:
      - pft_db_data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d

  pft-cache:
    volumes:
      - pft_cache_data:/data

volumes:
  pft_db_data:
  pft_cache_data:
```

### Data Directory Structure

```
.data/
├── pft/
│   ├── postgres/
│   │   └── <postgres data files>
│   ├── redis/
│   │   └── dump.rdb
│   └── uploads/
│       └── <user files>
├── umk/
│   └── ...
```

### Backup & Recovery

**Backup database:**
```bash
docker exec pft-db-dev pg_dump -U postgres dbname > ./backups/pft_db_backup.sql
```

**Restore:**
```bash
docker exec -i pft-db-dev psql -U postgres dbname < ./backups/pft_db_backup.sql
```

---

## Deployment Targets

### Development (Docker Compose)

**File:** `docker-compose.pft.yml`

```yaml
version: '3.8'
services:
  pft-db-dev:
    image: postgres:15
    container_name: pft-db-dev
    ports:
      - "5400:5432"
    environment:
      POSTGRES_DB: pft_dev
      POSTGRES_USER: ${PFT_DB_USER}
      POSTGRES_PASSWORD: ${PFT_DB_PASSWORD}
    volumes:
      - pft_db_data:/var/lib/postgresql/data
    networks:
      - pft-network

  pft-api:
    build: ./src/api
    container_name: pft-api-dev
    ports:
      - "5402:8080"
    environment:
      PFT_DB_HOST: pft-db-dev
      PFT_DB_PORT: 5432
      PFT_API_SECRET: ${PFT_API_SECRET}
    depends_on:
      - pft-db-dev
    networks:
      - pft-network

networks:
  pft-network:
    driver: bridge

volumes:
  pft_db_data:
```

**Usage:**
```bash
docker-compose -f docker-compose.pft.yml up -d
docker-compose -f docker-compose.pft.yml down
```

### Testing (Same as dev, or isolated)

**Option 1:** Use `docker-compose.pft.test.yml` with temp volumes
```bash
docker-compose -f docker-compose.pft.test.yml up -d --renew-anon-volumes
```

**Option 2:** Use in-memory services (if available)
```bash
# testcontainers or similar
pytest --testcontainers-postgres
```

### Production (Kubernetes or Nomad)

**Kubernetes example:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pft-db-prod
spec:
  containers:
  - name: postgres
    image: postgres:15
    ports:
    - containerPort: 5432
    env:
    - name: PFT_DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: pft-secrets
          key: db-password
    volumeMounts:
    - name: pft-db-storage
      mountPath: /var/lib/postgresql/data
  volumes:
  - name: pft-db-storage
    persistentVolumeClaim:
      claimName: pft-db-pvc
```

**Nomad example:**
```hcl
job "pft-db-prod" {
  datacenters = ["dc1"]
  type        = "service"

  group "postgres" {
    count = 1
    task "database" {
      driver = "docker"
      config {
        image = "postgres:15"
        ports = ["db"]
        env = [
          "PFT_DB_PASSWORD=${PFT_DB_PASSWORD}",
          "POSTGRES_DB=pft_prod"
        ]
      }
      resources {
        cpu    = 1000
        memory = 2048
      }
    }
  }
}
```

---

## Tool & Agent Restrictions

### Allowed Tools

✅ **All agents may use:**
- Docker / Docker Compose (for container management)
- `docker exec` (to access service shells)
- `docker logs` (to view logs)
- Container-based database clients (psql, mysql, redis-cli via `docker run`)

### Restricted Tools

❌ **Agents MUST NOT use on the host:**
- `psql` command-line tool (use via container only)
- `mysql` command-line tool (use via container only)
- Direct filesystem access to data directories (use volumes/mounts)
- Host network services (use containers and networks defined in this SOP)

### Rationale

- **Container isolation:** Services run in isolated, reproducible environments
- **No host pollution:** Host stays clean; no unintended dependencies on local tools
- **Feature separation:** Each feature's services are isolated in their own network
- **Easy cleanup:** Remove entire feature stack with `docker-compose down -v`

---

## Troubleshooting

### Service won't start

**Symptom:** `docker-compose up` fails with connection error

**Diagnosis:**
```bash
# Check if ports are already in use
lsof -i :5400

# Inspect compose logs
docker-compose -f docker-compose.pft.yml logs

# Check network
docker network inspect pft-network
```

**Solution:**
- Kill process on port: `kill -9 <PID>`
- Or change port in compose file and this SOP
- Ensure no other feature is using the same port range

### Can't connect to database from API container

**Symptom:** `psql: could not translate host name "pft-db-dev" to address`

**Diagnosis:**
```bash
# Check DNS from API container
docker exec pft-api-dev ping pft-db-dev

# Check compose network
docker-compose -f docker-compose.pft.yml exec api ping db
```

**Solution:**
- Ensure `networks: pft-network` is defined for both services
- Ensure `depends_on: - pft-db-dev` is set for API
- Rebuild network: `docker-compose down && docker-compose up`

### Permissions errors on volume mounts

**Symptom:** `Permission denied` when writing to volume

**Diagnosis:**
```bash
# Check volume permissions
docker volume inspect pft_db_data
ls -la .data/pft/
```

**Solution:**
- Adjust Dockerfile to run as correct user: `USER postgres`
- Or: `chmod 777 .data/pft/` (dev only; not for prod)

---

## Validation Checklist

Before marking this SOP as `active`, verify:

- [ ] All service names follow `<feature-id>-<service>-<tier>` pattern
- [ ] All environment variables follow `<FEATURE_ID>_*` prefix
- [ ] Docker Compose file (`docker-compose.pft.yml`) exists and is valid
- [ ] `docker-compose up -d` succeeds
- [ ] All services reach healthy state
- [ ] Database migrations run automatically or documented
- [ ] Logs are accessible via `docker logs` and file system
- [ ] Secrets are NOT committed to Git (`.env.local` is in `.gitignore`)
- [ ] All team members can start the stack independently
- [ ] Documentation is clear enough for a new agent to follow

---

## References

- **Feature Documentation:** `doc/<id>.<title>/`
- **Architecture Rules:** `doc/<id>.<title>/architecture-rules.md`
- **Constraints:** `doc/<id>.<title>/constraints.md`
- **Docker Compose Docs:** https://docs.docker.com/compose/
- **Docker Networking:** https://docs.docker.com/network/
- **Kubernetes Secrets:** https://kubernetes.io/docs/concepts/configuration/secret/

---

**Status:** Template (customize per-feature)  
**Created:** 2026-03-29  
**Template Version:** 1.0
