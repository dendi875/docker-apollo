# docker-apollo

原作者：https://github.com/foxiswho/docker-apollo

本docker 是针对 https://github.com/foxiswho/docker-apollo 的改动，支持添加自定义环境

[Docker image](https://hub.docker.com/r/foxiswho/docker-apollo/) for [Ctrip/Apollo](https://github.com/ctripcorp/apollo)(携程Apollo)

## Docker Tags:

- `1.1.0`

## 使用 Docker Compose 启动

建立一个`docker-compose.yaml`文件,内容如下,将mysql数据库地址与库名以及账号密码替换为自己的:

``` yaml
version: '3'

services:
  apollo:
    image: dendi875/docker-apollo:1.1.0
    container_name: apollo
    hostname: apollo
    volumes:
    - ./data:/opt
    ports:
      - "8070:8070"
      - "8080:8080"
      - "8090:8090"
      - "8081:8081"
      - "8091:8091"
      - "8082:8082"
      - "8092:8092"
      - "8083:8083"
      - "8093:8093"
      - "8084:8084"
      - "8094:8094"
    #restart: always
    environment:
      # 启动前，确认对应环境的数据库已经建立，否则apollo无法启动.
      # 端口:portal:8070; dev:8080,8090; fat:8081,8091; uat:8082,8092; pro:8083,8093;docker:8084,8094 
      
      # 开启Portal,默认端口: 8070
      PORTAL_DB: jdbc:mysql://192.168.99.200:3306/ApolloPortalDB?characterEncoding=utf8
      PORTAL_DB_USER: root
      PORTAL_DB_PWD: 123456

      # 开启env环境, 默认端口: config 8080, admin 8090
      DEV_DB: jdbc:mysql://192.168.99.200:3306/ApolloConfigDB?characterEncoding=utf8
      DEV_DB_USER: root
      DEV_DB_PWD: 123456
      DEV_CONFIG_PORT: 8080
      DEV_ADMIN_PORT: 8090

      # 开启自定义docker环境, 端口: config 8084, admin 8094
      DOCKER_DB: jdbc:mysql://192.168.99.200:3306/ApolloConfigDBDocker?characterEncoding=utf8
      DOCKER_DB_USER: root
      DOCKER_DB_PWD: 123456
      DOCKER_CONFIG_PORT: 8084
      DOCKER_ADMIN_PORT: 8094

      # 开启fat环境, 默认端口: config 8081, admin 8091
      #FAT_DB: jdbc:mysql://192.168.99.200:3306/ApolloConfigDBFat?characterEncoding=utf8
      #FAT_DB_USER: root
      #FAT_DB_PWD: 123456

      # 指定远程uat地址
      #UAT_URL: http://localhost:8080

      # 指定远程pro地址
      #PRO_URL: http://www.baidu.com:8080
```

*镜像包含Portal面板,以及Dev,Fat,Uat,Pro,Docker环境,皆可独立使用.若要开启相应环境,只需配置对应环境的env的数据库地址与账号密码。*

**启动前确认对应的数据库已建立,且数据库账号有权操作该库,否则将会启动失败.**[创建数据库指导](https://github.com/ctripcorp/apollo/wiki/%E5%88%86%E5%B8%83%E5%BC%8F%E9%83%A8%E7%BD%B2%E6%8C%87%E5%8D%97#21-%E5%88%9B%E5%BB%BA%E6%95%B0%E6%8D%AE%E5%BA%93)

**详细用法请看原作者[Wiki](https://github.com/idoop/docker-apollo/wiki)**

## 资源消耗

本镜像启动慢,且耗内存,因此有多开需求的请注意小鸡的内存是否够用. 

测试机为4核2.6G的x5650：

> 只启动Portal,用时20s,占内存280M.
>
> Portal+dev,用时90s,占内存999M.
>
> Portal+dev+fat,用时154s,占内存1674M.
>
> Protal+dev+fat+uat,自行估算.
>
> Protal+dev+fat+uat+pro,自行估算.
>
> Protal+dev+fat+uat+pro+docker,自行估算.

## Environment 参数

Portal:

> - PORTAL_DB: portal 的数据库地址, 留空则代表不开启
> - PORTAL_DB_USER: 数据库用户
> - PORTAL_DB_PWD: 数据库密码
> - PORTAL_PORT: portal服务的端口,默认8070.若网络模式为host,可更改.
> - DEV_URL: 远程dev服务,格式为http://**ip:port** 或 **domain:port** 不可与DEV_DB同时指定,数据库中ServerConfig中eureka.service.url的地址与端口需正确.
> - FAT_URL: 远程fat服务,格式为http://**ip:port** 或 **domain:port** 不可与FAT_DB同时指定,数据库中ServerConfig中eureka.service.url的地址与端口需正确.
> - UAT_URL: 远程uat服务,格式为http://**ip:port** 或 **domain:port** 不可与UAT_DB同时指定,数据库中ServerConfig中eureka.service.url的地址与端口需正确.
> - PRO_URL: 远程pro服务,格式为http://**ip:port** 或 **domain:port** 不可与PRO_DB同时指定,数据库中ServerConfig中eureka.service.url的地址与端口需正确.

Dev:

> - DEV_IP: 若使用分布式负载均衡,则输入负载均衡IP.
> - DEV_DB: dev 环境数据库地址, 留空则代表不开启
> - DEV_DB_USER: 数据库用户
> - DEV_DB_PWD: 数据库密码
> - DEV_ADMIN_PORT: admin服务端口,默认8090,若网络模式为host,可指定更改.
> - DEV_CONFIG_PORT: config服务端口,默认8080,若网络模式为host,可指定更改,需要与本数据库中的ServerConfig中eureka.service.url端口相同.

Fat:

> - FAT_IP: 若使用分布式负载均衡,则输入负载均衡IP.
> - FAT_DB: fat 环境数据库地址, 留空则代表不开启
> - FAT_DB_USER: 数据库用户
> - FAT_DB_PWD: 数据库密码
> - FAT_ADMIN_PORT: admin服务端口,默认8091.若网络模式为host,可指定更改.
> - FAT_CONFIG_PORT: config服务端口,默认8081.若网络模式为host,可指定更改,需要与本数据库中的ServerConfig中eureka.service.url端口相同.

Uat:

> - UAT_IP: 若使用分布式负载均衡,则输入负载均衡IP.
> - UAT_DB: uat 环境数据库地址, 留空则代表不开启
> - UAT_DB_USER: 数据库用户
> - UAT_DB_PWD: 数据库密码
> - UAT_ADMIN_PORT: admin服务端口,默认8092.若网络模式为host,可指定更改.
> - UAT_CONFIG_PORT: config服务端口,默认8082.若网络模式为host,可指定更改,需要与本数据库中的ServerConfig中eureka.service.url端口相同.

Pro:

> - PRO_IP: 若使用分布式负载均衡,则输入负载均衡IP.
> - PRO_DB: pro 环境数据库地址, 留空则代表不开启
> - PRO_DB_USER: 数据库用户
> - PRO_DB_PWD: 数据库密码
> - PRO_ADMIN_PORT: admin服务端口,默认8093.若网络模式为host,可指定更改.
> - PRO_CONFIG_PORT: config服务端口,默认8083.若网络模式为host,可指定更改,需要与本数据库中的ServerConfig中eureka.service.url端口相同.
>
> Docker:
>
> - DOCKER_IP: 若使用分布式负载均衡,则输入负载均衡IP.
> - DOCKER_DB: docker 环境数据库地址, 留空则代表不开启
> - DOCKER_DB_USER: 数据库用户
> - DOCKER_DB_PWD: 数据库密码
> - DOCKER_ADMIN_PORT: admin服务端口,默认8094.若网络模式为host,可指定更改.
> - DOCKER_CONFIG_PORT: config服务端口,默认8084.若网络模式为host,可指定更改,需要与本数据库中的ServerConfig中eureka.service.url端口相同.  