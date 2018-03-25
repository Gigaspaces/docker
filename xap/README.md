##  XAP In-Memory Data Grid

![XAP logo](https://docs.gigaspaces.com/images/logo-xap-color-small.png)

## What is XAP?

XAP is a cloud-native, high-throughput and low-latency application fabric that empowers real-time, event-driven microservices and distributed applications for Internet-scale innovation. XAP scales with your business needs, from simple data processing, to complex transactional workloads, all the way to leveraging hybrid storage and data center tiers.


XAP provides the following advantages:

- Enables your entire app to run entirely on a single platform with all the tiers collapsed into one container.
- Gives you fast data access by storing ALL your data in-memory. It also ensures high availability with in-memory backup within each container.
- Scales your app automatically and on demand.

To learn more about GigaSpaces products, visit the [website](https://www.gigaspaces.com).

***

## Table of Contents

- [Getting Started](#getting-started)
- [How to Use this Image](#how-to-use-this-image)
- [Running Your First Container](#running-your-first-container)
- [Running a Test Cluster on Your Host](#running-a-test-cluster-on-your-host)
- [Running a Production Cluster on Multiple Hosts](#running-a-production-cluster-on-multiple-hosts)
- [Beyond the Basics](#beyond-the-basics)
    - [Running other CLI commands](#running-other-cli-commands)
    - [Using a Different Java Version](#using-a-different-java-version)
    - [Accessing the Logs](#accessing-the-xap-logs)

# Getting Started

To test the XAP Docker image, run the following in your command line to display a help screen with all the available commands: 

```
docker run gigaspaces/xap help
```


 For example, the `version` command prints version information:

```
docker run gigaspaces/xap version
```

# How to Use this Image

The XAP Docker image utilizes GigaSpaces' XAP command line interface (CLI). To learn more about the command line interface, see [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.



# Running Your First Container

The simplest and fastest way to start working with XAP is to get a single instance up and running on your local machine.  After the instance is initiated, you can start to explore the various features and capabilities.

To run a single host on your machine:

```
docker run --name test -it --net=host gigaspaces/xap
```


When running the XAP Docker image without arguments, a host is automatically started in demo mode, with a lookup service and a space called `demo-space` comprised of 2 partitions. In order for a client to connect to this space, you can use one of the following:

* Run the client in docker as well on the same host, using the `pu run` command line.
* Use the `--net=host` option - docker will run the container on the same host as the network (works only on linux hosts)
* configure the client lookup settings to the docker bridge network (172.17.0.x).


# Running a Production Cluster on Multiple Hosts

By default, docker containers run in an isolated network,using port mapping to communicate with external services and clients. While this has advantages, it reduces performance as it incurs an additional network hop. As per Docker documentation, to get optimal performance it's recommended to use the `--net=host` option, which uses the host network. This means you cannot run more than one container per host, but for production environments this is not a limitation, as there's no need to run more than one container.

For this scenario, let's assume there are 5 hosts named `test1`..`test5`, similar to the previous example.  On each host, run the following:
```
XAP_MANAGER_SERVERS=host1,host2,host3
docker run --name test -it --net=host -e XAP_MANAGER_SERVERS gigaspaces/xap
```
## Beyond the Basics

# Running other CLI commands

The XAP Docker image utilizes GigaSpaces' XAP command line interface (CLI). Any arguments following the image name are passed to the command line. 

If no arguments are specified after the image, the default command will be run: `demo`

To learn more about the command line interface, see [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.


# Using a Different Java Version

This XAP Docker image is based on the official [openjdk](https://hub.docker.com/_/openjdk/) image, and uses Java version 8. To use a different Java version, you have to build a new image using the `JAVA_TAG` build argument. For example:
```
docker build --build-arg JAVA_TAG=9 -t gigaspaces/xap:openjdk-9 .
```
If you're not sure which versions are available, refer to the [supported tags](https://hub.docker.com/r/library/openjdk/tags/) page.

You can also build from a different base image, or even create your own, using the `JAVA_IMAGE` build argument (e.g. `--build-arg JAVA_IMAGE=...`)

#  Accessing the Logs

All logs are stored in `opt/gigaspaces/logs` within the container. To access to the logs, you can do one of the following:

- Use the `-v` option in your `docker run` command to map this to a folder on your host.
- Use the `docker cp` command to copy the files from a Docker instance to a location on your host.

To mount the directory to get the logs, use the following command:
```
 -v c:/gigaspaces/test/logs:/opt/gigaspaces/logs
```
To copy logs from a running instance, use the following command:
```
docker cp containerId:/opt/gigaspaces/logs .
```
