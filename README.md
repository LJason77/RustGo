# RustGo

RustGo written for lobsters🦞

# 编译镜像

```
git clone --depth=1 https://github.com/LJason77/RustGo.git
cd RustGo
docker build -t rust-go .
```

# 配置

创建一个 `config.json` 文件，比如：

```
{
    "server": "my_server_ip",
    "server_port": 8388,
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "mypassword",
    "timeout": 300,
    "method": "aes-256-gcm"
}
```

# 运行

```
docker run -d --name rust-go --restart always -v /your/path/config.json:/config.json rust-go
```