##  InsightEdge platform

![InsightEdge logo](https://www.gigaspaces.com/sites/default/files/solutions/logo-insightedge-color-small.png)

## What is InsightEdge Enterprise?

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

To test the InsightEdge Enterprise Docker image, run the following in your command line to display a help screen with all the available commands: 

```
docker run gigaspaces/insightedge-enterprise help
```


 For example, the `version` command prints version information:

```
docker run gigaspaces/insightedge-enterprise version
```

# How to Use this Image

The InsightEdge Enterprise Docker image utilizes GigaSpaces' command line interface (CLI). To learn more about the command line interface, see [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.

The InsightEdge Enterprise image requires a license key to run, which can be provided using the `XAP_LICENSE` environment variable. You can use the `tryme` license, which enables you to use the full InsightEdge product for 24 hours (and then terminates the image), or you can  get a longer [evaluation license](http://gigaspaces.com/eval-license).


# Running Your First Container

The simplest and fastest way to start working with InsightEdge Enterprise is to get a single instance up and running on your local machine.  After the instance is initiated, you can start to explore the various features and capabilities.

To run a single host on your machine:

```
docker run --name test -it -e XAP_LICENSE=tryme gigaspaces/insightedge-enterprise
```

When running the InsightEdge Enterprise Docker image without arguments, a host is automatically started with the following components:

* XAP Manager (mapped to port `8090`) [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/xap-manager.html)
* Web Management Console (mapped to port `8099`) [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/tools-web-ui.html)
* Spark Master (mapped to port `8080`)
* Spark Worker (mapped to port `8081`)
* Apache Zeppelin (mapped to port `9090`)

In order for a client to connect to these services, you can use one of the following:

* Run the client in Docker as well on the same host.
* Use the `--net=host` option - Docker will run the container on the same host as the network (works only on Linux hosts).
* Configure the client lookup settings to the Docker bridge network (172.17.0.x).
* Use `-p` to map the ports from the container to the host.

# Running a Test Cluster on Your Host

If you want to test high availability or other distributed features on a single host, you can start multiple instances of InsightEdge. All you need to do is assign identities so they can communicate with each other, and specify which containers will run the XAP Manager service. For example:

```
XAP_MANAGER_SERVERS=host1,host2,host3
XAP_LICENSE=tryme
docker run --name test1 -h=host1 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/insightedge-enterprise
docker run --name test2 -h=host2 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/insightedge-enterprise
docker run --name test3 -h=host3 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/insightedge-enterprise
docker run --name test4 -h=host4 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/insightedge-enterprise
docker run --name test5 -h=host5 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/insightedge-enterprise
```

Due to starting multiple management containers on the same host, the ports of the 2nd and 3rd containers must be mapped to different host ports, in order to avoid conflicts with the 1st container. The rest of the containers don't expose any ports; they are connected to the management nodes via Docker's default bridge network, and are managed through the Web Management Console or REST Manager API. [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/xap-manager-rest.html)

# Running a Production Cluster on Multiple Hosts

By default, Docker containers run in an isolated network, using port mapping to communicate with external services and clients. While this has advantages, it reduces performance because it requires an additional network hop. As per Docker documentation, to get optimal performance it is recommended to use the `--net=host` option, which uses the host network. This means you can't run more than one container per host, but for production environments this isn't a limitation, because there's no need to run more than one container.

For this scenario, let's assume there are 5 hosts named `test1`..`test5`, similar to the previous example.  On each host, run the following:
```
XAP_MANAGER_SERVERS=host1,host2,host3
XAP_LICENSE=tryme
docker run --name test -it --net=host -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/insightedge-enterprise
```
## Beyond the Basics

# Running Other CLI Commands

As mentioned earlier, the InsightEdge Enterprise Docker image utilizes GigaSpaces' command line interface (CLI). Any arguments following the image name are passed to the command line. For example, to run the command `insightedge host list` via Docker, simply run:

```
docker run -it gigaspaces/insightedge-enterprise host list
```

If no arguments are specified after the image, the default command is run: `host run-agent --auto`

To learn more about the command line interface, refer to the [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.


# Using a Different Java Version

This XAP Enterprise Docker image is based on the official [openjdk](https://hub.docker.com/_/openjdk/) image, and uses Java version 8. To use a different Java version, you have to build a new image using the `JAVA_TAG` build argument. For example:
```
docker build --build-arg JAVA_TAG=9 -t gigaspaces/insightedge-enterprise:openjdk-9 .
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
