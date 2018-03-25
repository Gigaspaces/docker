##  InsightEdge platform

![InsightEdge logo](https://www.gigaspaces.com/sites/default/files/solutions/logo-insightedge-color-small.png)

## What is InsightEdge?

The InsightEdge platform, a combination of the XAP in-memory data grid and an open-source analytics ecosystem, is an in-memory insight platform that supports fast-data analytics, artificial intelligence and real-time applications. Customers can use this platform to develop their own systems that provide instant data-driven insights with time-to-analytics at a sub-second scale. InsightEdge also enables hyperscaling analytics from SQL, and streaming to machine learning via Apache Spark.

The InsightEdge platform provides extreme performance with ultra-low latency, high-throughput transactions and stream processing, due to the co-location of applications and analytics. All of this functionality is available in a cloud-native, infrastructure-agnostic deployment for hybrid cloud and on-premises environments.

To learn more about GigaSpaces products, visit the [website](https://www.gigaspaces.com).

***

## Table of Contents

- [Getting Started](#getting-started)
- [How to Use this Image](#how-to-use-this-image)
- [Running Your First Container](#running-your-first-container)
- [Running a Test Cluster on Your Host](#running-a-test-cluster-on-your-host)
- [Running a Production Cluster on Multiple Hosts](#running-a-production-cluster-on-multiple-hosts)
- [Beyond the Basics](#beyond-the-basics)
    - [Running Other CLI Commands](#running-other-cli-commands)
    - [Using a Different Java Version](#using-a-different-java-version)
    - [Accessing the Logs](#accessing-the-logs)

# Getting Started

To test the InsightEdge Docker image, run the following in your command line to display a help screen with all the available commands: 

```
docker run gigaspaces/insightedge help
```


 For example, the `version` command prints version information:

```
docker run gigaspaces/insightedge version
```

# How to Use this Image

The InsightEdge Docker image utilizes GigaSpaces' command line interface (CLI). To learn more about the command line interface, see [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.



# Running Your First Container

The simplest and fastest way to start working with InsightEdge is to get a single instance up and running on your local machine.  After the instance is initiated, you can start to explore the various features and capabilities.

To run a single host on your machine:

```
docker run --name test -it --net=host gigaspaces/insightedge
```


When running the InsightEdge Docker image without arguments, a host is automatically started in demo mode, with a lookup service and a Space called `demo-space` comprised of 2 partitions. In addition, it starts a Spark Master, Spark Worker and Apache Zeppelin. In order for a client to connect to these services, you can use one of the following:

* Run the client in Docker as well on the same host.
* Use the `--net=host` option - Docker will run the container on the same host as the network (works only on Linux hosts).
* Configure the client lookup settings to the Docker bridge network (172.17.0.x).
* Use `-p` to map the ports from the container to the host.


# Running a Production Cluster on Multiple Hosts

By default, Docker containers run in an isolated network, using port mapping to communicate with external services and clients. While this has advantages, it reduces performance as it requires an additional network hop. As per Docker documentation, to get optimal performance it is recommended to use the `--net=host` option, which uses the host network. This means you can't run more than one container per host, but for production environments this isn't a limitation, as there's no need to run more than one container.

## Beyond the Basics

# Running Other CLI Commands

The InsightEdge Docker image utilizes GigaSpaces' command line interface (CLI). Any arguments following the image name are passed to the command line. 

If no arguments are specified after the image, the default command will be run: `demo`

To learn more about the command line interface, refer to the [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.


# Using a Different Java Version

This InsightEdge Docker image is based on the official [openjdk](https://hub.docker.com/_/openjdk/) image, and uses Java version 8. To use a different Java version, you have to build a new image using the `JAVA_TAG` build argument. For example:
```
docker build --build-arg JAVA_TAG=9 -t gigaspaces/insightedge:openjdk-9 .
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
