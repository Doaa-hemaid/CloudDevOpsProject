# Ansible for Infrastructure Management
## Overview
Outlines the structure of the Ansible roles and playbooks used for managing infrastructure.
The setup includes roles for Docker, Jenkins, OpenShift, PostgreSQL, and SonarQube, with separate playbooks for the master and slave nodes. 
The infrastructure configuration is managed using an inventory file.

## 1.  Directory Structure

  The directory structure for the Ansible roles is as follows:

```plaintext
ansible/roles/
├── Docker
│   └── tasks
│       └── main.yaml
├── Jenkins
│   └── tasks
│       └── main.yaml
├── OpenShift
│   └── tasks
│       └── main.yaml
├── postgresql
│   ├── defaults
│   │   └── main.yml
│   └── tasks
│       └── main.yml
└── SonarQube
    ├── defaults
    │   └── main.yml
    ├── tasks
    │   └── main.yml
    └── templates
        ├── 99-sonarqube.conf.j2
        └── sonar.properties.j2
```



## 2. Inventory File (`inventory.ini`)

The `inventory.ini` file contains details of the master and slave nodes that Ansible will target for different tasks:

```ini
[master]
master-node ansible_host=18.208.226.145 ansible_user=ubuntu ansible_ssh_private_key_file=Ec2Key.pem

[slave]
slave-node ansible_host=34.229.112.72 ansible_user=ubuntu ansible_ssh_private_key_file=Ec2Key.pem
```

- The **master** group includes the master node.
- The **slave** group includes the slave node.

Each node is identified by its IP address and requires the private key `Ec2Key.pem` for SSH access.

## 3. Playbooks

### 3.1 Common Tasks (`commonTasks.yml`)

The `commonTasks.yml` playbook is used to install OpenJDK 17 and other prerequisites on all nodes. 
It also ensures the installation of tools like `curl`, `tar`, `unzip`, and `software-properties-common`.

```yaml
- hosts: all
  become: yes
  tasks:
    - name: Install OpenJDK 17 and prerequisites (curl, tar,..etc)
      apt:
        name:
          - openjdk-17-jdk
          - curl
          - tar
          - unzip
          - apt-transport-https
          - ca-certificates
          - software-properties-common
        state: present
        update_cache: yes
```

### 3.2 Master Node Playbook (`masterPlaybook.yml`)

The `masterPlaybook.yml` playbook applies the **Jenkins** role to the master node. This role installs and configures Jenkins on the master node.

```yaml
- hosts: master
  become: yes
  roles:
    - Jenkins
```

### 3.3 Slave Node Playbook (`slavePlaybook.yml`)

The `slavePlaybook.yml` playbook applies various roles to the slave node, such as **Docker**, **OpenShift**,  **PostgreSQL**, and **SonarQube**).

```yaml
- hosts: slave
  become: yes
  roles:
     - Docker
     - OpenShift
     - postgresql
    - SonarQube
```

## Conclusion

This Ansible setup efficiently manages infrastructure by separating tasks into roles and applying them to the appropriate nodes.
The playbooks for the master and slave nodes allow for flexible configuration of both types of machines with tailored roles.

---

