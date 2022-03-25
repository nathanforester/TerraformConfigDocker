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

    - name: clone app repo
      command: git clone https://github.com/nathanforester/APIPrimeAge.git

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

sudo touch /home/ubuntu/.ssh/Estio-Training-NForester

sudo chmod 777 /home/ubuntu/.ssh/Estio-Training-NForester

sudo cat <<EOT > /home/ubuntu/.ssh/Estio-Training-NForester
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAlO9us+PsI45z5dMXU4A0Tbd7DXZ6nejDe404xuOSqDsfZxUd
3briE5C48lMzy6E8K3TFCY1MZgyAOc7ljNLLYJ8VzSBb6JRRsHAc0MJfVd3VGFf6
PRYrwAZ1mY9nen73CbYUcycNCwBgAFl9S15pVSnTzGwp+rb8HBBV7/wOFvkVzZR7
jFPprF3YhPyw64W1RyHxA+uCS2T8LGmyYt4gC4PMibJEaG96HdX0U9zcM50LT0HK
E5UgnTPWqsYScIf8KtutghQyrIdFiVeteCLOvGQJk66IavX2mLsFoYAk9kMEL8w0
pMxxXte7KblHF4ridciJXUJWWtmx3av+HC1S1QIDAQABAoIBAGFVMNXjqJl8KYYT
NHVfnc8EkCi2O2AjlE2Ud3yTkW7cZKNri38y+TisJhJICduUXcxQncymST2QAeTF
sAMeZ8eXcBoEgcw30kMqocpUnRVyyicEqAdwC9uM3SIkNA48F5qDIk43QTDlZ9gS
o+2zn8cGdOJt9elh2NVGX8NcyKB92IgenX0P3CC5HWco5uWA49X+t/ySjDOpHt78
/Lwocxy1+4/qDV2Np8K7Y7wNkUKVEGyhFsrJs6KO1y7eIhInMoJvVzTBwIVhz5iy
/S95DEA+YLtcHcGpYJc+I3blcOimpcCUnkIYf71VsqLWjC2y6L3SlKWBDNO0wX+F
z+DuIMECgYEA7VKfIkN9BcrS0GAolrLL9kQ6QmwjSBXtW9zStELgaQRlvfv15Rh1
0Nu01+B/TPzk/6lo4mLRDjwiQcJjrQbnqZGT/3aEhymjtTKSoQ2BcRGpok7nIGBQ
kDVmbmRZdj0ZUK9sp+gUIg2sQ0lNxAlF0FtrCD5fRirBnoWOjvSnSJ0CgYEAoKgO
DG7DHFlvyY/RL20M8ItfC5CzuKK4mzSugiD22HsUNHYOicCXCvU+qMLIGYX8TFWE
iRXcJSVRjONhLuM6qOwo3S4dfMaABuj0YELC9X1uBZ22oMD6MJopAFu2cgHV2gvp
sBsCrZnkCrgjmeMJapuYOIWlvGuFY853T0q6kZkCgYEAmq/Y07+DlSvvnyyeKCPg
d+Neyf6sPIc2UEMt/5r7pNfd7Sh2zV3VJU6foHpO34KTTOVCXRUlyI5/kbc/uv8e
LtOZ0NCSb3s/npKZKmqgLW/izs15Lww4VtbHrjqwaTZH8uR1AThvLwcUekMkchvN
KpL7v8LP3O9vhoDtO9bR1q0CgYEAmh0cfOiz2johdmWz8Z7Wztmjr2B8Rx4xoRGE
ZehhY4GN/FVT1Oke+7APD6zqbzGMuV0/6pFBwZBvDowA6g2oc+s3uBVIzC1PG1HV
O5JPm1dbd5+3VbZJSt5XfrR77Bm+n5DV982xX/9ENtQ1sqWMnuvrtizetEUgjIG/
Ch1Ro+ECgYEAqoCC2OJ1Oz+ZeeBbpKlyJ2BEqMXmCAsf5tiKTDprVuNmp1Ft7XAd
V6R0gZW8bWYj183Bw5GWTXAYUsStZU/1UEZ33eF8I3uZaPEtuqMHXMnUZtcQV6ts
FGSBuJ1Px8T9uzoek8qUr/cbOzjtZLWOUgmLcCrbVyi3dGQLYCP4ZXM=
-----END RSA PRIVATE KEY-----
EOT

sudo chown ubuntu /home/ubuntu/.ssh/Estio-Training-NForester

sudo chmod 600 /home/ubuntu/.ssh/Estio-Training-NForester

sudo echo 'ubuntu ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo

