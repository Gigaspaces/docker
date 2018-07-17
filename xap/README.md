##  XAP In-Memory Data Grid

![XAP logo](https://docs.gigaspaces.com/images/logo-xap-color-small.png)

## What is XAP?

XAP is a cloud-native, high-throughput and low-latency application fabric that empowers real-time, event-driven microservices and distributed applications for Internet-scale innovation. XAP scales with your business needs, from simple data processing, to complex transactional workloads, all the way to leveraging hybrid storage and data center tiers.


XAP provides the following advantages:

- Enables your complete app to run in its entirety on a single platform, with all the tiers collapsed into one container.
- Gives you fast data access by storing ALL your data in-memory, and ensures high availability using in-memory backup within each container.
- Scales your app automatically and on demand.

To learn more about GigaSpaces products, visit the [website](https://www.gigaspaces.com).

***

## Table of Contents

- [Getting Started](#getting-started)
- [How to Use this Image](#how-to-use-this-image)
- [Running Your First Container](#running-your-first-container)
- [Running a Production Cluster on Multiple Hosts](#running-a-production-cluster-on-multiple-hosts)
- [Beyond the Basics](#beyond-the-basics)
    - [Running Other CLI Commands](#running-other-cli-commands)
    - [Using a Different Java Version](#using-a-different-java-version)
    - [Accessing the Logs](#accessing-the-logs)

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

The XAP Docker image utilizes GigaSpaces' command line interface (CLI). To learn more about the command line interface, see [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.



# Running Your First Container

The simplest and fastest way to start working with XAP is to get a single instance up and running on your local machine.  After the instance is initiated, you can start to explore the various features and capabilities.

To run a demo on your machine:
```
docker run --name test -it gigaspaces/xap
```

When running this image without arguments, it's automatically started in demo mode, with a lookup service and a Space called `demo-space` comprised of 2 partitions. 

Since docker runs containers in a bridge network by default, a client that wants to connect to this Space should use one of the following options:

### Run client with Docker Bridge Network

By default, the client uses the host network interface. You can configure the client to use the docker bridge network interface (usually 172.17.0.x) using the `XAP_NIC_ADDRESS` environment variable, so it'll be able to contact and interact with the space.

* Note: This works only for clients on the same host - the docker bridge network is inaccessible to other hosts.

### Run client in another docker container

Docker containers on the same host use the same bridge network. If the client is a processing unit, you can run it via another docker container with the `pu run` command.

* Note: This works only for clients on the same host - docker containers on other hosts will use a different bridge network.

### Use the Host Network

Docker can run containers on the host network using the `--net=host` option with the `docker run` command. In this case, the client will be able to connect and interact with the space without additional configuration.

* Note: Docker supports the `--net=host` option only on Linux hosts.

### Configure XAP public host

By default, XAP communication protocol (LRMI) uses the same network interface for both binding and publishing. You can modify this and use the `XAP_PUBLIC_HOST` enviromnent variable to instruct XAP to publish itself using a different network address, e.g. the host's network address. In this case you'll also need to expose some ports from the docker container to the host. For example:

```
docker run --name test -it -e XAP_PUBLIC_HOST=<your-host-ip-or-name> -p 4174:4174 -p 8200-8300:8200-8300 gigaspaces/xap
```

# Ports

This image uses the ports described in the table below. You can change each port using the respective environment variable, or simply map it to a different port using the `-p` option in `docker run` (e.g. `-p 5174:4174` maps the lookup discovery port to a different port, but maintains the same port within the container).

| Environment variable | Default value | Description |
| ---------------------|---------------|-------------|
| XAP_LOOKUP_PORT      | 4174          | Lookup discovery port [(docs)](https://docs.gigaspaces.com/xap/12.3/admin/network-lookup-service-configuration.html) |
| XAP_LRMI_PORT        | 8200-8300     | Network protocol port range [(docs)](https://docs.gigaspaces.com/xap/12.3/admin/tuning-communication-protocol.html) |

# Running a Production Cluster on Multiple Hosts

When running on multiple hosts, you need to either configure `XAP_PUBLIC_HOST` or use the `--net=host` option as described above, so containers on different hosts can interact with each other. 

The `XAP_PUBLIC_HOST` complies with common practices of docker usage, and maintains image isolation. However, as per Docker documentation, to get optimal performance it is recommended to use the `--net=host` option, which uses the host network and removes the extra network hop. Both options are supported by this image - it's up to you to choose which one better suites your needs.

## Beyond the Basics

# Running Other CLI Commands

The XAP Docker image utilizes GigaSpaces' command line interface (CLI). Any arguments following the image name are passed to the command line. 

If no arguments are specified after the image, the default command will be run: `demo`

To learn more about the command line interface, refer to the [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.


# Using a Different Java Version

This XAP Docker image is based on the official [openjdk](https://hub.docker.com/_/openjdk/) image, and uses Java version 8. To use a different Java version, you have to build a new image using the `JAVA_TAG` build argument. For example:
```
docker build --build-arg JAVA_TAG=9 -t gigaspaces/xap:openjdk-9 .
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

