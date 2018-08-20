##  InsightEdge Enterprise

![InsightEdge logo](https://www.gigaspaces.com/sites/default/files/solutions/logo-insightedge-color-small.png)

## What is InsightEdge Enterprise?

The InsightEdge platform, a combination of the XAP in-memory data grid and an open-source analytics ecosystem, is an in-memory insight platform that supports fast-data analytics, artificial intelligence and real-time applications. Customers can use this platform to develop their own systems that provide instant data-driven insights with time-to-analytics at a sub-second scale. InsightEdge also enables hyperscaling analytics from SQL, and streaming to machine learning via Apache Spark.

Insightedge Enterprise provides the following advantages:

- Enables your complete app to run in its entirety on a single platform, with all the tiers collapsed into one container.
- Gives you fast data access by storing ALL your data in-memory, and ensures high availability using in-memory backup within each container.
- Scales your app automatically and on demand.
- Gives extreme performance with ultra-low latency, high-throughput transactions and stream processing, due to the co-location of applications and analytics. All of this functionality is available in a cloud-native, infrastructure-agnostic deployment for hybrid cloud and on-premises environments.

To learn more about GigaSpaces products, visit the [website](https://www.gigaspaces.com).

***

## Table of Contents

- [Getting Started](#getting-started)
- [How to Use this Image](#how-to-use-this-image)
- [Running Your First Container](#running-your-first-container)
- [Connecting to the Client](#connecting-to-the-client)
- [Running the Client with the Docker Bridge Network](#running-the-client-with-the-docker-bridge-network)
- [Running the Client in another Docker Container](#running-the-client-in-another-docker-container)
- [Using the Host Network](#using-the-host-network)
- [Configuring the Public Host](#running-the-client-with-the-docker-bridge-network)
- [Running a Production Cluster on Multiple Hosts](#configuring-the-public-host)
- [Beyond the Basics](#beyond-the-basics)
    - [Configuring the XAP_MANAGER_SERVER IP Address](#configuring-the-xap-manager-server-ip-address)
    - [Ports](#ports)
    - [Running Other CLI Commands](#running-other-cli-commands)
    - [Using a Different Java Version](#using-a-different-java-version)
    - [Accessing the Logs](#accessing-the-logs)

# Getting Started

To test the InsightEdge Enterprise Docker image, run the following in your command line to display a help screen with all the available commands: 

```
docker run gigaspaces/insightedge-enterprise --help
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

* Platform Manager (mapped to port `8090`) [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/xap-manager.html)
* Web Management Console (mapped to port `8099`) [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/tools-web-ui.html)
* Spark master (mapped to port `8080`)
* Spark worker (mapped to port `8081`)
* Apache Zeppelin (mapped to port `9090`)

*Note: These ports are mapped to your host, so you can access them.*


# Connecting to the Client

Docker runs containers in a bridge network by default. You can use any of the options described below to enable a client to connect to the Space.

### Running the Client with the Docker Bridge Network

By default, the client uses the host network interface. You can configure the client to use the Docker bridge network interface (the IP address is usually 172.17.0.x). Use the `XAP_NIC_ADDRESS` environment variable to enable the client to contact and interact with the Space.

**NOTE: This only works for clients that reside on the same host as the Space. The Docker bridge network is inaccessible to other hosts.**

### Running the Client in Another Docker Container

Docker containers that reside on the same host use the same bridge network. If the client is in a Processing Unit, you can run it via another Docker container with the `pu run` command.

**NOTE: This only works for clients that reside on the same host as the Space. Docker containers on other hosts will use a different bridge network.**

### Using the Host Network

Docker can run containers on the host network using the `--net=host` option with the `docker run` command. In this case, the client can connect and interact with the Space without additional configuration.

**NOTE: Docker only supports the `--net=host` option on Linux hosts.**

### Configuring the Public Host

By default, the XAP core communication protocol (LRMI) uses the same network interface for both binding and publishing. You can modify this, using the `XAP_PUBLIC_HOST` enviromnent variable to instruct InsightEdge Enterprise to publish itself using a different network address, for example the host's network address. In this case, you'll have to expose the ports listed in the [Ports](#ports) section from the Docker container to the host. For example:

```
docker run --name test -it -e XAP_LICENSE=tryme -e XAP_PUBLIC_HOST=<your-host-ip-or-name> -p 4174:4174 -p 8200-8300:8200-8300 gigaspaces/insightedge-enterprise
```
# Running a Production Cluster on Multiple Hosts

When running InsightEdge Enterprise in Docker containers on multiple hosts, you need to either configure `XAP_PUBLIC_HOST` or use the `--net=host` option as described above, so that containers on different hosts can interact with each other.

The `XAP_PUBLIC_HOST` environment variable complies with common practices of Docker usage, and maintains image isolation. However, as per the Docker documentation, to get optimal performance it is recommended to use the `--net=host` option, which uses the host network and removes the extra network hop. The InsightEdge Enterprise Docker image supports both options, so choose the one that best suits your needs.

## Beyond the Basics

# Configuring the `XAP_MANAGER_SERVER` IP Address

When running InsightEdge Enterprise on multiple hosts, you can configure the IP address for the Platform Manager in your network in the `XAP_MANAGER_SERVERS` environment variable. `XAP_MANAGER_SERVERS=host1,host2,host3` by default is the local manager.

# Ports

The InsightEdge Enterprise Docker image uses the ports described in the table below. You can change each port using the respective environment variable, or map it to a different port using the `-p` option in `docker run`. For example, `-p 5174:4174` maps the lookup discovery port to a different port, but maintains the same port within the container.

| Environment Variable                      | Default Value | Description |
| ------------------------------------------|---------------|-------------|
| XAP_LOOKUP_PORT                           | 4174          | Lookup discovery port. [(learn more)](https://docs.gigaspaces.com/xap/12.3/admin/network-lookup-service-configuration.html) |
| XAP_LRMI_PORT                             | 8200-8300     | Network protocol port range. [(learn more)](https://docs.gigaspaces.com/xap/12.3/admin/tuning-communication-protocol.html) |
| XAP_MANAGER_REST_PORT                     | 8090          | REST Manager API port. [(learn more)](https://docs.gigaspaces.com/xap/12.3/admin/xap-manager-rest.html) |
| WEBUI_PORT                                | 8099          | Web Management Console port [(learn more)](https://docs.gigaspaces.com/xap/12.3/admin/tools-web-ui.html) |
| XAP_WEBSTER_HTTP_PORT                     | 8199          | Internal web service used as part of the application deployment process. |
| XAP_RMI_REGISTRY_PORT                     | 10098-10108   | Used to communicate with client application. |
| XAP_ZOOKEEPER_CLIENT_PORT                 | 2181          | Used for the Zookeeper client. |
| XAP_MANAGER_ZOOKEEPER_DISCOVERY_PORT      | 2888          | Used for the Zookeeper discovery ports. |
| XAP_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT| 3888          | Used for the Zookeeper leader election port. |
| SPARK_MASTER_PORT                         | 7077          | Spark Master port. [(learn more)](https://spark.apache.org/docs/0.8.0/spark-standalone.html) |
| SPARK_MASTER_WEBUI_PORT                   | 8080          | Spark Master Web UI port. [(learn more)](https://spark.apache.org/docs/0.8.0/spark-standalone.html) |
| SPARK_MASTER_REST_PORT                    | 6066          | Spark Master REST port. [(learn more)](https://spark.apache.org/docs/0.8.0/spark-standalone.html) |
| ZEPPELIN_PORT                             | 9090          | Insightedge Apache Zeppelin port. [(learn more)](https://docs.gigaspaces.com/xap/12.3/started/insightedge-zeppelin.html) |

# Running Other CLI Commands

The Insightedge Enterprise Docker image utilizes GigaSpaces' command line interface (CLI). Any arguments following the image name are passed to the command line.

If no arguments are specified after the image, the default `host run-agent --auto` command will be run.

To learn more about the command line interface, refer to the [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.


# Using a Different Java Version

This InsightEdge Enterprise Docker image is based on the official [openjdk](https://hub.docker.com/_/openjdk/) image, and uses Java version 8. To use a different Java version, you have to build a new image using the `JAVA_TAG` build argument. For example:
```
docker build --build-arg JAVA_TAG=9 -t gigaspaces/insightedge-enterprise:openjdk-9 .
```
If you're not sure which versions are available, refer to the [supported tags](https://hub.docker.com/r/library/openjdk/tags/) page.

You can also build from a different base image, or even create your own, using the `JAVA_IMAGE` build argument (e.g. `--build-arg JAVA_IMAGE=...`)

#  Accessing the Logs

All logs are stored in `opt/gigaspaces/logs` within the container. To access the logs, you can do one of the following:

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
