# 通讯错误返回实例

1. 客户端错误

    ```json
    {
        "result_code": "400",
        "error_code": "TERMINAL_NOT_EXISTS",
        "error_message": "不存在这个终端",
    }
    ```

2. 客户端错误

    ```json
    {
        "result_code": "400",
        "error_code": "INVALID_PARAMETER",
        "error_message": "client_sn不可以为空；total_amount不可以为负数",
    }
    ```

3. 服务端错误

    ```json
    {
        "result_code": "500",
        "error_code": "UNKNOWN_SYSTEM_ERROR",
        "error_message": "未知的系统错误",
    }
    ```

4. 服务端系统错误

    ```json
    {
        "result_code": "500",
        "error_code": "MAINTENANCE_INPROGRESS",
        "error_message": "服务端正在升级维护，稍候5分钟",
    }
    ```
