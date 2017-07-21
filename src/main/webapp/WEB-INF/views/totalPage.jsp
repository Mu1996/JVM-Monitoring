<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>jvm数据汇总</title>
    <script type="text/javascript" src="/resource/ichart.1.2.min.js"></script>
    <script>
        //定义ajax函数
        function ajax(options) {
            options = options || {};
            options.type = (options.type || "GET").toUpperCase();
            options.dataType = options.dataType || "json";
            var params = formatParams(options.data);
            //创建 - 非IE6 - 第一步
            var xhr = new XMLHttpRequest();
            //接收 - 第三步
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4) {
                    var status = xhr.status;
                    if (status >= 200 && status < 300) {
                        options.success
                        && options.success(xhr.responseText,
                            xhr.responseXML);
                    } else {
                        options.fail && options.fail(status);
                    }
                }
            }
            //连接 和 发送 - 第二步
            if (options.type == "GET") {
                xhr.open("GET", options.url + "?" + params, true);
                xhr.send(null);
            } else if (options.type == "POST") {
                xhr.open("POST", options.url, true); //设置表单提交时的内容类型
                xhr.setRequestheaper("Content-Type",
                    "application/x-www-form-urlencoded");

                xhr.send(params);
            }
        }

        //格式化参数到url
        function formatParams(data) {
            var arr = [];
            for (var name in data) {
                arr.push(encodeURIComponent(name) + "="
                    + encodeURIComponent(data[name]));
            }
            arr.push(("v=" + Math.random()).replace(".", ""));
            return arr.join("&");
        }
    </script>
    <style>
        pre {
            outline: 1px solid #ccc;
            padding: 5px;
            margin: 5px
        }

        .string {
            color: green;
        }

        .number {
            color: darkorange;
        }

        .boolean {
            color: blue;
        }

        .null {
            color: magenta;
        }

        .key {
            color: red;
        }
    </style>
</head>
<body>
<script type="text/javascript">
    var hostip = "localhost:8080";

    function getAllInfo() {
        ajax({
            url: "http://" + hostip + "/getAllInfo",
            type: "GET",
            needToken: false,
            dataType: "json",
            success: function (response) {
                var r = JSON.parse(response);
                document.getElementById("result").innerHTML = syntaxHighlight(r);

            },
            fail: function (response) {
            }
        })
    }

    function syntaxHighlight(json) {
        if (typeof json != 'string') {
            json = JSON.stringify(json, undefined, 2);
        }
        json = json.replace(/&/g, '&').replace(/</g, '<')
            .replace(/>/g, '>');
        return json
            .replace(
                /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g,
                function (match) {
                    var cls = 'number';
                    if (/^"/.test(match)) {
                        if (/:$/.test(match)) {
                            cls = 'key';
                        } else {
                            cls = 'string';
                        }
                    } else if (/true|false/.test(match)) {
                        cls = 'boolean';
                    } else if (/null/.test(match)) {
                        cls = 'null';
                    }
                    return '<span class="' + cls + '">' + match
                        + '</span>';
                });
    }

    getAllInfo();
    window.setInterval(getAllInfo, 5000);
</script>
<pre id="result">

</pre>
</body>
</html>