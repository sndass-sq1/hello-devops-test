# hello-devops: lab starter for the 3-day DevOps bootcamp

One small website that the trainees ship (Day 1), containerise (Day 2) and secure (Day 3).

## Trainer setup (once, before Day 1)

1. Create a **public** GitHub repository from this folder and push it.
2. In that repo: Settings > General > tick **Template repository**.
3. Write the repo URL on the whiteboard. Trainees click **Use this template** and name their copy `hello-devops`.

## What is in here

| Path | Used on | What it is |
|---|---|---|
| `site/` | all days | The website: `index.html`, `style.css`, `greet.js` |
| `test/greet.test.js` | Day 1 | Two unit tests, run with `node --test` |
| `maze/make-maze.sh` | Day 1 | Linux treasure hunt. Run `bash maze/make-maze.sh` in Git Bash |
| `day1/ci.yml` | Day 1 | Pipeline: test, build, deploy to GitHub Pages. Copy to `.github/workflows/ci.yml` |
| `day2/Dockerfile` | Day 2 | Copy to the repo root, then `docker build -t hello-devops:1.0 .` |
| `day2/k8s.yaml` | Day 2 | Deployment (2 pods) and NodePort Service on `localhost:30080` |
| `day3/bad-commit/` | Day 3 | Deliberately insecure files, copied over the project at the start of the lab |
| `day3/security.yml` | Day 3 | Six security gates. Copy to `.github/workflows/security.yml` |
| `day3/semgrep-rules.yml`, `day3/zap-rules.tsv` | Day 3 | Rules used by the SAST and DAST gates |
| `day3/fixes/` | Day 3 | A ready-made fix for every gate |

## Day 3 answer key

| Gate | Tool | Cause | Fix |
|---|---|---|---|
| 1 Secret scan | gitleaks | `site/config.js` holds a token and password | `git rm site/config.js` |
| 2 SAST | Semgrep | `site/search.js` puts URL input into `innerHTML` | use `textContent` (or copy `day3/fixes/site/search.js`) |
| 3 SCA | Trivy | `lodash` 4.17.15 has known HIGH vulnerabilities | copy `day3/fixes/package.json` and `package-lock.json` |
| 4 Image scan | Trivy | `FROM nginx:1.19` | copy `day3/fixes/Dockerfile` and `day3/fixes/nginx/` |
| 5 IaC scan | Trivy | SSH open to `0.0.0.0/0` in `infra/main.tf` | change to `10.20.0.0/16` |
| 6 DAST | OWASP ZAP | no `X-Frame-Options` / `X-Content-Type-Options` headers | same Dockerfile fix as gate 4 |

The secrets in `day3/bad-commit/site/config.js` are made up and unlock nothing.
