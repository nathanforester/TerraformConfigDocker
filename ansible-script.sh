#!bin/bash

sudo apt update

sudo apt install ansible -y

sudo touch /home/ubuntu/playbook.yaml 

sudo touch /home/ubuntu/inventory.yaml

sudo chmod 777 /home/ubuntu/playbook.yaml 

sudo chmod 777 /home/ubuntu/inventory.yaml

cat <<ENDL > /home/ubuntu/playbook.yaml
- hosts: jenkins  
  become: yes
  vars:
    docker_compose_version: "1.27.4"
  tasks:

    - name: Update apt cache
      apt: update_cache=yes cache_valid_time=3600

    - name: Upgrade all apt packages
      apt: upgrade=dist

    - name: Install dependencies
      apt:
        name: "{{ packages }}"
        state: present
        update_cache: yes
      vars:
        packages:
        - openjdk-8-jre
        - curl
        - git
        - acl

    - name: Clone remote application repository
      command: git clone https://github.com/nathanforester/FlaskMovieDB

    - name: Add jenkins user and append to admin group
      user:
        name: jenkins
        shell: /bin/bash
        password: ''
        groups: admin
        append: yes
    
    - name: Allow 'jenkins' user to have passwordless sudo
      lineinfile:
        dest: /etc/sudoers
        state: present
        line: 'jenkins ALL=(ALL) NOPASSWD:ALL'
        validate: 'visudo -cf %s'

    - name: Import a key from a url
      ansible.builtin.apt_key:
        url: https://pkg.jenkins.io/debian/jenkins.io.key
        state: present

    - name: download jenkins binary
      command: sh -c "echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list"
      
    - name: Update apt cache
      apt: update_cache=yes cache_valid_time=3600

    - name: install jenkins
      apt:
        name: jenkins
        state: present
        update_cache: yes

    - name: Just force systemd to re-execute itself
      ansible.builtin.systemd:
        daemon_reload: yes
        scope: system

    - name: start service jenkins
      ansible.builtin.systemd:
        name: jenkins
        state: started
        scope: system

    - name: Update apt cache
      apt: update_cache=yes cache_valid_time=3600

    - name: Upgrade all apt packages
      apt: upgrade=dist

    - name: Install dependencies
      apt:
        name: "{{ packages }}"
        state: present
        update_cache: yes
      vars:
        packages:
        - apt-transport-https
        - ca-certificates
        - curl
        - software-properties-common
        - gnupg-agent
      
    - name: Add an apt signing key for Docker
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add apt repository for stable version
      apt_repository:
        repo: deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable
        state: present

    - name: Install Docker
      apt:
        name: "{{ packages }}"
        state: present
        update_cache: yes
      vars:
        packages:
        - docker-ce
        - docker-ce-cli 
        - containerd.io

    - name: Add user to docker group
      user:
        name: "{{ansible_user}}"
        group: docker

    - name: Download docker-compose {{ docker_compose_version }}
      get_url:
        url : https://github.com/docker/compose/releases/download/{{ docker_compose_version }}/docker-compose-Linux-x86_64
        dest: ~/docker-compose
        mode: '+x'

    - name: Check docker-compose exists
      stat: path=~/docker-compose
      register: docker_compose

    - name: Move docker-compose to /usr/local/bin/docker-compose
      command: mv ~/docker-compose /usr/local/bin/docker-compose
      when: docker_compose.stat.exists

- hosts: deploy
  become: yes
  ignore_errors: true 
  vars:
    docker_compose_version: "1.27.4"
  tasks:

    - name: Update apt cache
      apt: update_cache=yes cache_valid_time=3600

    - name: Upgrade all apt packages
      apt: upgrade=dist

    - name: Install dependencies
      apt:
        name: "{{ packages }}"
        state: present
        update_cache: yes
      vars:
        packages:
        - apt-transport-https
        - ca-certificates
        - curl
        - software-properties-common
        - gnupg-agent
      
    - name: Add an apt signing key for Docker
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add apt repository for stable version
      apt_repository:
        repo: deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable
        state: present

    - name: Install Docker
      apt:
        name: "{{ packages }}"
        state: present
        update_cache: yes
      vars:
        packages:
        - docker-ce
        - docker-ce-cli 
        - containerd.io

    - name: Add user to docker group
      user:
        name: "{{ansible_user}}"
        group: docker

    - name: Download docker-compose {{ docker_compose_version }}
      get_url:
        url : https://github.com/docker/compose/releases/download/{{ docker_compose_version }}/docker-compose-Linux-x86_64
        dest: ~/docker-compose
        mode: '+x'

    - name: Check docker-compose exists
      stat: path=~/docker-compose
      register: docker_compose

    - name: Move docker-compose to /usr/local/bin/docker-compose
      command: mv ~/docker-compose /usr/local/bin/docker-compose
      when: docker_compose.stat.exists

- hosts: jenkins
  become: yes
  tasks:

    - name: admin password jenkins
      command: sudo cat /var/lib/jenkins/secrets/initialAdminPassword
ENDL

cat <<ENDL > /home/ubuntu/inventory.yaml
all:
  children:
    jenkins:
      hosts:
        10.0.1.20:
    deploy:
      hosts:
        10.0.1.10:
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: "/home/ubuntu/.ssh/Estio-Training-NForester"
    ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
ENDL

sudo chmod 640 /home/ubuntu/playbook.yaml

sudo chmod 640 /home/ubuntu/inventory.yaml

sudo chown ubuntu /home/ubuntu/playbook.yaml

sudo chown ubuntu /home/ubuntu/inventory.yaml

sudo touch /home/ubuntu/.ssh/<key_name>

sudo chmod 777 /home/ubuntu/.ssh/<key_name>

sudo cat <<EOT > /home/ubuntu/.ssh/<key_name>
<insert key data here>
EOT

sudo chown ubuntu /home/ubuntu/.ssh/<key_name>

sudo chmod 600 /home/ubuntu/.ssh/<key_name>

sudo echo 'ubuntu ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo

