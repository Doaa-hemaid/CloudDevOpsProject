# Application Deployment with Roles
Deployment of applications using Ansible roles. The roles are designed to automate the installation and setup of the following tools:
- **Docker**
- **Jenkins**
- **OpenShift CLI (OC)**
 ### Roles

 #### 1. **Docker**
 This role automates the installation and configuration of Docker. The tasks are defined in   
 `roles/Docker/tasks/main.yaml`.

 #### 2. **Jenkins**
 This role sets up Jenkins, including its installation and any necessary configurations. The tasks for this role are located in `roles/Jenkins/tasks/main.yaml`.

 #### 3. **OpenShift CLI (OC)**
 This role handles the installation and configuration of the OpenShift CLI (OC) tool. The tasks for this role are defined in   
 `roles/OpenShift/tasks/main.yaml`.  
 
![2024-12-05 00_25_05-root@ubuntu_ ~_Ivolve-training_Ansible_Lab4](https://github.com/user-attachments/assets/ff2d7479-5465-4830-bd99-a3185d920ede)

---
## Creating a Playbook to Run the Roles
**Create a Playbook File**
```yaml
- hosts: all
  become: yes
  roles:
    - Docker
    - Jenkins
    - OpenShift
```
**Run the Playbook**
```bash 
ansible-playbook i inventory.ini playbook.yml
```
![run lab4](https://github.com/user-attachments/assets/7915e345-b591-443b-a7cf-35bc12469590)
