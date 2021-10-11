# NSS-Cloud Report

## 1 System Goals (1 point)

### 1.1 Qualitative Goals
- mention of some use cases and desired goals
- privacy

### 1.2 Quantitative Goals
- performance
- reliability

### 1.3 Use Cases
- personal clound for storing and sharing family pictures etc.
- self-made home security camera system (old android phone -> over-tls-stream -> openCV for object detection -> nextcloud as userinterface)

## 2 System architecture
### 2.1 Nextcloud server architecture

![Figure 1](fig-1-nextcloud-setup.png)

Figure 1 - Scalable Nexcloud setup example. NFS (Network file system) as storage layer, an LDAP (Lightweight Directory Access Protocol) user directory, caching, databases and load balancer.  [\[NC-WP\]](#nc-wp)

In principle Nextcloud server is a web application based on PHP and can be run with any webserver, such as Apache or NGINX. The core of Nextcloud provides storage of file sharing information, user details, application data, configuration and file information in database (MySQL, MariaDB and PostegreSGL are supported). Additional features are available with added services and setup. Plenty of NFS soulutions work natively with Nextcloud. [\[NC-WP\]](#nc-wp)

To access data, but also to configure, monitor and manage, Nextcloud provides intuitive interface through web browser, Android, iOS or desktop applications. Alternatively resources can handled via WebDAV standard API. 

### 2.2 NSS-cloud adoption
Since our primary goal is a personal use of the cloud infrastructure (see [1.3 Use Cases](#1.3-use-cases)) we do not expect high traffic environment and the whole system should comfortably fit on low spec consumer hardware (e.g. NUC). Therefore our practical application has been concluded as follows:

- The server system runs within a single VM (Ubuntu 20.04, 1 vCPU, 1GB RAM)
- The Nextcloud has been natively installed and configured
- It utilises PostegreSQL which is running in constrained environment of a container
	- 256MB storage with 256MB additional swap space from vHDD and allowed to use upmost 0.5 vCPU
	- the communication protocol between Nextcloud and database is TLS 1.3 (TLS_AES_256_GCM_SHA384)
- Clients connect through web browser using secure HTTPS connection with Let's Encrypt certificate

## 3 Components
	Components / Module description including the interfaces exposed between the modules

All in VM, and with Apache. Exposed ports for HTTPS and SSH connections.

### 3.1 Nextcloud
Direct installation.

TLS 1.3 to database

HTTPS to clients

### 3.2 PostegreSQL
Database in a docker container connected via TLS 1.3.

### 3.3 LDAP
TBC

### 3.4 Certification BOT
Let's Encrypt certificate maintainer.

Interface? (http/https for updates? File system (saving cert on drive) for internal communication?)

### 3.5 Clients
Throug web browser portal over HTTPS. (TBC test app)

## 4 Communicaiton
	Communication channel between the modules. For instance, do the modules use secure communication to communicate with each other, if yes, how?

Already hinted in previous chapter

- server and client over HTTPS
	- how

- nextcloud and database over TLS


## 5 Open source modules evaluation
	Pros and cons of the open-source components/modules used for developing the system, and the modules/components you have built (3 points)

*Open source is the way forward and any proprietary solution should be heavily build on open source. No need to keep reinventing wheel. (TBC reference based open source rant?)*

### Nextcloud
pros:
- free
- beginner friendly base and basic setup
- decent documentation
- auditability -  serves the privacy and security qualitative goal, as an end user can audit the system themself without requiring to put trust in third parties

cons:
- 

### Let's Encrypt


### Optional nss-ca
certificate chain generation and signing script. Based on widely used OpenSSL.
- good enough for personal usage
- openssl and crypto in general is not easy and user friendly
- cannot be trustworthy otherwise

Bla bla bla OpenSSL crap and ambiguous documentation etc.

## 6 Fallacies
	Which of the fallacies of the distributed system does your system violate, and how?

### 6.1 Network is reliable
- check if nextcoud mitigades e.g. upload interrupts / session resumption etc (I'd assume so since basic HTTPS config generally supports this on lower levels)

### 6.2 Latency is zero
- personal network (local), we do not care so much about the latency
- may be considered for self hosting somewhere and implementing e.g. WebRTC based audio/video chat

### 6.3 Infinite bandwidth
- TBC

### 6.4 Network is secure
Our system secures client communication with HTTPS and internal with TLS. Further consideration could be made to run the system in HSM based secure VM (e.g AMD-SEV/SNP, Intel TDX or Arm CCA in the future) or shifting the system to a container rather than VM and bootstrapping it with HSM (Intel SGX, RISC-V Keystone, TPM 2.0 etc.). This would secure internal communication and compute to the extent that even a physical access to the system would not reveal any sensitive information*.

*We're aware of side channel attacks vulnerabilities of mentioned systems and their are out of the scope of this project.

### 6.5 Topology doesn’t change
- TBC

### 6.6 There is one administrator
Nextcloud support multiple administrators, and further specified roles can be delegated to support customized administration topology. [\[NC-WP\]](#nc-wp)

The undelying OS (Ubuntu 20.04) can be as well configured to support multiple users with various administrative priviliedges. **(Some Reference here)**

### 6.7 Transport cost is zero
- TBC (I think a. for our use case of local network we can more or less asume this, b. in Finland the internet access is almost free so zero cost for our consumers?)

### 6.8 Network is homogeneous
The Nextcloud and our solution supports various communication protocols and APIs.

## 7 Further development
	What needs to be added to your system be used to be integrated/extended by another system.

### 7.1 Deployment
**Refactor needed**

Despite personal use as main target environment, it would be nice to have some kind of automated deployment script (Especially when things go sideways). From our experience the setup can be done quite quick, but it still is tedious and requires time and certain level of expertise. Definitely not for non-IT user / consumer.

Nextcloud maintains stable docker container configuration, which is a good place to start.

### 7.2 Federation
- add trusted to have multiple instances running together (federation)

### 7.3 Additional Services and Features
Nextcloud provides user friendly *app store* where once can pick from many available services (e.g. something something, voice channel)

Further WebDAV standard complient API gives an opportunity to indenpendently create custom services if one is of coding nature.

### 7.X Others
- cetrificate


## 8 Evaluation.
	Methodology used for evaluating the system performance, and the key results

- latency, throughput / bandwidth?

## 9 Conclusion / Learning

Nextcloud feels like a great DIY cloud playground.


## Resources
<a id="nc-wp">\[NC-WP\]</a> - Nextcloud Solution Architecture whitepaper. [Link](https://nextcloud.com/media/wp135098u/Architecture-Whitepaper-WebVersion-072018.pdf). Accessed 09.10.2021.