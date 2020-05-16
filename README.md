# vdbench-tests
This repo contains some of the tests I used to benchmark distributed storage solutions such as Portworx, Ceph and GlusterFS.
The ***purpose*** of these tests is to evaluate the performance of a shared filesystem by simulating a near real-world workload:
* multiple hosts are connected to the same storage
* there are mixed VFS operations running at the same time: read, write, getattr, setattr, delete etc
* disk access is random
* the IO size is variable
* the files sizes are variable


## Requirements
* Any modern Linux distro on which you can install Java v1.7+

## Setup
We assume the following:
* we had exported a shared filesystem volume (eg: a NFS share)
* we mounted the volume on both worker1 and worker2 as /vdbench
* Java is installed on the master and the workers
* We have enough memory on the workers for the [Vdbench's Java HEAP](https://github.com/iul1an/vdbench-tests/blob/master/vdbench/vdbench#L39)

For running the tests, we will use 3 machines:

| Hostname | Role                                                     |
|----------|----------------------------------------------------------|
| master   | Master node, the tests will be initiated from this node  |
| worker1  | Worker node, this node will actually run the tests       |
| worker2  | Worker node, this node will actually run the tests       |


We setup passwordless SSH access between the master and the workers by running the following commands on the master node:
* Create SSH RSA key:
```
ssh-keygen -t rsa
```
* Copy the public key on the workers:
```
ssh-copy-id root@worker1
ssh-copy-id root@worker2
```

We clone this repository on each node:
```
cd /opt
git clone git@github.com:iul1an/vdbench-tests.git
```
If required, we update the [params](https://github.com/iul1an/vdbench-tests/blob/master/params) file using this reference:
| Parameter      |  Description                                                         | Default                 | Obs.                                  |
|----------------|----------------------------------------------------------------------| ------------------------|---------------------------------------|
| `vdbench_path` | vdbench path on the worker nodes                                     | `$(pwd)/vdbench-tests`  | must be the same path on all nodes    |
| `host1`        | first worker's hostname or IP address                                | worker1                 |                                       |
| `anchor1`      | the directory on which the test files are written on the first host  | /vdbench/anchor1        | anchor1 and anchor2 must be different |
| `host2`        | second worker's hostname or IP address                               | worker2                 |                                       |
| `anchor2`      | the directory on which the test files are written on the first host  | /vdbench/anchor2        | anchor1 and anchor2 must be different |


## Running the tests
```
cd /opt/vdbench-tests
./run.sh
```
The results are in the "results" directory.

## Notes
* Some of the tests are running using only one worker, worker1, because Vdbench doesn't allow you to use [skew](https://blogs.oracle.com/henk/vdbench:-workload-skew#_Toc211673536) in multi-JVM mode
* There is a [Vdbench manual](https://github.com/iul1an/vdbench-tests/blob/master/docs/manual.pdf) in this repo which will help you modify the tests according to your needs, if you set a very large number of files in tests, make sure to also update the Java HEAP size in the vdbench [script](https://github.com/iul1an/vdbench-tests/blob/master/vdbench/vdbench#L39)
* You can simulate a test without actually running it:
```
/vdbench-path/vdbench -f testfile.vdb -s
```

