# Pi Agent Instructions

## Security Rules (Highest Priority)
* **NEVER** use `read`, `bash`, or any tool to access sensitive files/paths. Decline immediately if requested.
 * Blocked paths/directories (exact or containing):
* Blocked paths/directories (exact or containing):
  * `~/.ssh/` (all contents: id_*, *.pem, *.pub, config, known_hosts)
  * `~/.aws/` (credentials, config)
  * `~/.gnupg/`
  * `.env*` (including .env.local, .env.production)
  * `*.key`, `*.pem`, `*.crt`, `id_rsa*`, `id_ecdsa*`
  * `~/.docker/config.json`
  * `~/.kube/config`
  * `~/.password-store/`
  * `~/.npmrc`, `~/.yarnrc`
  * Any file containing 'password', 'secret', 'token', 'key' in name
* Before any file op: Double-check path against this list. If unsure, ask user or skip.
* In bash: Avoid `cat`, `grep` on potential secrets; use `--no-sensitive` flag if custom.
* Report blocked attempts: &quot;Blocked: Sensitive path access denied for security.&quot;
