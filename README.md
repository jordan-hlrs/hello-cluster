# `hello-jobstep`
This project ist forked from 
https://code.ornl.gov/olcf/hello_jobstep.git
but with an adjusted Makefile and a pbs jobscript to make it work on Hunter.

This repository is a test repository for git clone behind a fire wall and an example for affilation and pinning for Hunter.

This program is used to test process, thread, and GPU binding for job steps launched with Slurm's `srun` command. It prints the hardware thread IDs that each MPI rank and OpenMP thread runs on as well as the GPU IDs that each rank/thread has access to.

## Compiling

All necessary modules should be loaded by default. If you purged them, either log in again or run:
module load PrgEnv-cray
module load HLRS/APU/2026.1

## Setting Up the Tunnel

Choose a port number between **10000 and 60000** and connect:

```bash
local> MY_PROXY_PORT=XXXXX
local> ssh -R localhost:$MY_PROXY_PORT \
           -i ~/.ssh/HLRS_cs_XXXXXXXX \
           hunter.hww.hlrs.de
```

The tunnel stays open as long as your SSH session is open.
Close the session when you are done.

## Using the Tunnel: Proxy Variables

On Hunter, set the proxy environment variables using the same port:

```bash
hunter> MY_PROXY_PORT=XXXXX
hunter> export https_proxy=socks5://localhost:$MY_PROXY_PORT
hunter> export http_proxy=$https_proxy
```

### Clone and build on Hunter

```
$ git clone https://github.com/jordan-hlrs/hello-cluster.git
$ cd hello-cluster
Inside jobscript.pbs, change <your email> to your email to get notified about job start and end.
$ make
```

## Usage

You should develop and build your projects inside your $HOME but run your program inside your workspace.
A typical workflow would be:

### 1. One-time setup: if the workspace doesn't exist yet:
ws_allocate hello_exercise 7
ln -s $(ws_find hello_exercise) $HOME/hello_exercise

### 1. (alternative) if the workspace already exists, check remaining time:
ws_list -s hello_exercise
#### if it's running low, extend it (max duration is 60):
ws_extend hello_exercise 7

### 2. Development cycle (repeat as needed)
cd $HOME/hello-cluster
#### ... edit source ...
make

### 3. Deploy
cp -r build $HOME/hello_exercise/hello-cluster

### 4. Submit
cd $HOME/hello_exercise/hello-cluster
qsub jobscript.pbs

Example content of the output file 'logfilename.log':
```
MPI 000 - OMP 000 - HWT 002 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 001 - HWT 003 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 002 - HWT 004 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 003 - HWT 005 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 004 - HWT 006 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 005 - HWT 007 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 006 - HWT 008 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 007 - HWT 009 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 008 - HWT 010 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 009 - HWT 011 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 010 - HWT 012 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 011 - HWT 013 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 012 - HWT 014 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
MPI 000 - OMP 013 - HWT 015 - Node x1001c1s1b0n0 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 02
...
```

### Explanation of Reported IDs

| ID          | Description                                              |
|:-----------:|----------------------------------------------------------|
| `MPI`       | MPI rank ID                                              |
| `OMP`       | OpenMP thread ID                                         |
| `HWT`       | CPU hardware thread the MPI rank or OpenMP thread ran on |
| `Node`      | Compute node the MPI rank or OpenMP thread ran on        |
| `RT_GPU_ID` | The runtime GPU ID the rank or thread had access to      |
| `GPU_ID`    | The node-level GPU ID the rank or thread had access to   |
| `Bus_ID`    | The physical bus ID associated with a GPU                |

#### ADDITIONAL NOTES:

* `GPU_ID` is the node-level (or global) GPU ID read from `ROCR_VISIBLE_DEVICES`. If this environment variable is not set (either by the user or by Slurm), the value of `GPU_ID` will be set to `N/A`.
* `RT_GPU_ID` is the HIP runtime GPU ID (as reported from, say `hipGetDevice`).
* `Bus_ID` is the physical bus ID associated with the GPUs. Comparing the bus IDs is meant to definitively show that different GPUs are being used.

## Examples

For examples, please see the [GPU Mapping section](https://kb.hlrs.de/platforms/index.php/Affinity_and_Pinning) on the Hunter Wiki. 

----------------
