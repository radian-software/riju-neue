# Riju Neue

Project to rewrite some components of
[Riju](https://github.com/radian-software/riju) from scratch to fix
architectural issues. If this sees the light of day, it means the
project was a success.

## Design concerns

Central issue is that we need to run untrusted user code in an
isolated environment. Another design principle is we want to minimize
costs as much as possible.

## Architecture

The frontend is served on Netlify as a fully static site. The backend
is served directly from a single EC2 instance with an Elastic IP
address attached, to save on needing to pay for a load balancer. The
server is stateless, so multiple instances can be run in parallel.
This is leveraged to perform zero-downtime deployments of the
underlying machine image: the old instance is set as a tombstone to
redirect all traffic to the new instance's Elastic IP address while
DNS changes propagate.

Most system configuration occurs in EC2 user data, with credentials
pulled from Parameter Store using the EC2 instance profile, to avoid
having to rebuild the machine image too often.

User code is run on a dynamic pool of EC2 instances that are
discovered through the AWS API on the basis of their tags. Normally
this will only feature a single instance, to save on costs.

Worker instances are blocked from public internet access by security
group. They expose a simple web server for low-level job scheduling
and management. Using this API, the server instance can: create a
Docker container from a specific image, ping it to keep it from being
garbage collected automatically by the worker server, and proxy HTTP
requests into a port exposed by the container.

User code is executed inside worker instance containers using an agent
server binary that is mounted read-only into the containers. When the
API server submits a request to the worker server to create a
container, it also (in addition to the Docker image path) specifies
the revision (or content-addressable hash) of the agent server binary
to download, cache, and mount into the container.

Standard input and output in user code are proxied to the frontend
using websockets. Both the API server and worker server have websocket
proxying ability. The user's web browser is the eventual websocket
client while the server agent binary is the eventual websocket server.

The server agent binary includes functionality to execute a command in
an emulated pty environment, and transform its input and output into a
linear bidirectional stream that can be transported over websocket.

Each language has a unified configuration file describing all aspects
of its installation and usage. From that configuration file a Debian
package can be generated which can be used to install the language on
a compatible release of Ubuntu. By installing the package on top of an
Ubuntu base image, per-language Docker images can be generated.
Compiled Debian packages are stored on AWS S3 while Docker images are
stored on GitHub Container Registry (GHCR). Compiled server agent
binaries are also stored on AWS S3.

Workload orchestration and deployment occurs via MicroK8s which is
installed in the server AMI and then accessed via kubectl, pulling
images from GHCR.

Persistent state (about what Docker images are used for what
languages, and what server agent binary versions are active, etc.) is
stored in a self-hosted PostgreSQL database on a separate node in the
MicroK8s cluster.

All code is in Go.
