#cloud-config
package_reboot_if_required: false

package_update: true

package_upgrade: false

packages:

  - git 
  - curl
  - docker.io 

write_files:
  - path: /.env
    permissions: '0644'
    content: |
      REDIS_HOST=${redis_host}
      DB_HOST=${db_host}
      DB_USER=user
      DB_PASSWORD=password
      DB_NAME=mydatabase



final_message: |
  cloud-init has finished
  version: $version
  timestamp: $timestamp
  datasource: $datasource
  uptime: $uptime