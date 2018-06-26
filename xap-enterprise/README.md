##  XAP In-Memory Data Grid

![XAP logo](https://docs.gigaspaces.com/images/logo-xap-color-small.png)

## What is XAP Enterprise?

XAP Enterprise is a cloud-native, high-throughput and low-latency application fabric that empowers real-time, event-driven microservices and distributed applications for Internet-scale innovation. XAP Enterprise scales with your business needs, from simple data processing to complex transactional workloads, all the way to leveraging hybrid storage and data center tiers.


XAP Enterprise provides the following advantages:

- Enables your complete app to run in its entirety on a single platform, with all the tiers collapsed into one container.
- Gives you fast data access by storing ALL your data in-memory, and ensures high availability using in-memory backup within each container.
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
    - [Running Other CLI Commands](#running-other-cli-commands)
    - [Using a Different Java Version](#using-a-different-java-version)
    - [Accessing the Logs](#accessing-the-logs)

# Getting Started

To test the XAP Enterprise Docker image, run the following in your command line to display a help screen with all the available commands: 

```
docker run gigaspaces/xap-enterprise help
```


 For example, the `version` command prints version information:

```
docker run gigaspaces/xap-enterprise version
```

# How to Use this Image

The XAP Enterprise Docker image utilizes GigaSpaces' command line interface (CLI). To learn more about the command line interface, see [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.

The XAP Enterprise image requires a license key to run, which can be provided using the `XAP_LICENSE` environment variable. You can use the `tryme` license, which enables you to use the full XAP product for 24 hours (and then terminates the image), or you can  get a longer [evaluation license](http://gigaspaces.com/eval-license).


# Running Your First Container

The simplest and fastest way to start working with XAP Enterprise is to get a single instance up and running on your local machine.  After the instance is initiated, you can start to explore the various features and capabilities.

To run a single host on your machine:

```
docker run --name test -it -e XAP_LICENSE=tryme -p 8090:8090 -p 8099:8099 gigaspaces/xap-enterprise
```

When running the XAP Enterprise Docker image without arguments, a host is automatically started with the following components:

* XAP Manager (mapped to port `8090`) [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/xap-manager.html)
* Web Management Console (mapped to port `8099`) [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/tools-web-ui.html)

*Note: These ports are mapped to your host, so you can access them.*

# Running a Test Cluster on Your Host

If you want to test high availability or other distributed features on a single host, you can start multiple instances of XAP. All you need to do is assign identities so they can communicate with each other, and specify which containers will run the XAP Manager service. For example:

```
XAP_MANAGER_SERVERS=host1,host2,host3
XAP_LICENSE=tryme
docker run --name test1 -h=host1 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS -p 8090:8090 -p 8099:8099 gigaspaces/xap-enterprise
docker run --name test2 -h=host2 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS -p 8091:8090 -p 8100:8099 gigaspaces/xap-enterprise
docker run --name test3 -h=host3 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/xap-enterprise
docker run --name test4 -h=host4 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/xap-enterprise
docker run --name test5 -h=host5 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/xap-enterprise
```

Due to starting multiple management containers on the same host, the ports of the 2nd and 3rd containers must be mapped to different host ports, in order to avoid conflicts with the 1st container. The rest of the containers don't expose any ports; they are connected to the management nodes via Docker's default bridge network, and are managed through the Web Management Console or REST Manager API. [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/xap-manager-rest.html)

# Running a Production Cluster on Multiple Hosts

By default, Docker containers run in an isolated network, using port mapping to communicate with external services and clients. While this has advantages, it reduces performance because it requires an additional network hop. As per Docker documentation, to get optimal performance it is recommended to use the `--net=host` option, which uses the host network. This means you can't run more than one container per host, but for production environments this isn't a limitation, because there's no need to run more than one container.

For this scenario, let's assume there are 5 hosts named `test1`..`test5`, similar to the previous example.  On each host, run the following:

__Required attributes__
```
XAP_MANAGER_SERVERS=host1,host2,host3
XAP_PUBLIC_HOST=<machine public ip>
XAP_LICENSE=tryme
```

__Optional attributes the written values are default, you can overwrite it.__
```
XAP_LOOKUP_PORT=4174
XAP_LRMI_PORT=8200-8300
XAP_MANAGER_REST_PORT=8090
WEBUI_PORT=8099
XAP_WEBSTER_HTTP_PORT=8199
XAP_RMI_REGISTRY_PORT=10098

XAP_ZOOKEEPER_CLIENT_PORT=2181
XAP_MANAGER_ZOOKEEPER_DISCOVERY_PORT=2888
XAP_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT=3888
```
__Run with private/public ip and port forwarding (use above configuration)__
```

docker run --name test -it -e XAP_PUBLIC_HOST=<machine public ip> -e XAP_MANAGER_SERVERS=host1,host2,host3 -e XAP_LICENSE=<tryme> -p 4174:4174 -p 8199:8199 -p 8200-8300:8200-8300 -p 8090:8090 -p 8099:8099 -p 10098:10098 -p 2181:2181 -p 2888:2888 -p 3888:3888 gigaspaces/xap-enterprise
```
__Run with --net=host__
```
docker run --name test -it --net=host -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/xap-enterprise
```
## Beyond the Basics

# Running Other CLI Commands

As mentioned earlier, the XAP Enterprise Docker image utilizes GigaSpaces' command line interface (CLI). Any arguments following the image name are passed to the command line. For example, to run the command `xap host list` via Docker, simply run:

```
docker run -it gigaspaces/xap-enterprise host list
```

If no arguments are specified after the image, the default command is run: `host run-agent --auto`

To learn more about the command line interface, refer to the [CLI documentation](https://docs.gigaspaces.com/xap/12.3/admin/tools-cli.html "CLI documentation"), or use the `--help` option.


# Using a Different Java Version

This XAP Enterprise Docker image is based on the official [openjdk](https://hub.docker.com/_/openjdk/) image, and uses Java version 8. To use a different Java version, you have to build a new image using the `JAVA_TAG` build argument. For example:
```
docker build --build-arg JAVA_TAG=9 -t gigaspaces/xap-enterprise:openjdk-9 .
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
