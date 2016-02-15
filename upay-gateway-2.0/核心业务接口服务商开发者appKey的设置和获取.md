### 设置服务商开发者appKey

   * 示例

```sh
$ curl -X POST -H "Content-Type: application/json" http://core-business.test.shouqianba.com/rpc/vendor -d @- <<EOF
{
   "method": "resetAppKey",
   "params": ["1" ],
   "id": 1
}
EOF
{"jsonrpc":"2.0","id":1,"result":"947653eaad55ee99c313dbd3ffe7a295"}
```

   * 参数说明

    | 位置 | 取值 | 说明 |
    |-----|------|-----|
    | 1 | 1 | vendor_sn 服务商序列号，不可为空 |

   * 返回值为服务商新的appKey


### 获取服务商appKey

   * 示例

```sh
$ curl -X POST -H "Content-Type: application/json" http://core-business.test.shouqianba.com/rpc/vendor -d @- <<EOF
{
   "method": "getAppKey",
   "params": ["1" ],
   "id": 1
}
EOF
{"jsonrpc":"2.0","id":1,"result":"947653eaad55ee99c313dbd3ffe7a295"}
```

   * 参数说明

    | 位置 | 取值 | 说明 |
    |-----|------|-----|
    | 1 | 1 | vendor_sn 服务商序列号，不可为空 |

   * 返回值为服务商新的appKey

