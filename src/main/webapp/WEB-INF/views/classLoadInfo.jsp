<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
                        options.success && options.success(xhr.responseText, xhr.responseXML);
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
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                xhr.send(params);
            }
        }


        //格式化参数到url
        function formatParams(data) {
            var arr = [];
            for (var name in data) {
                arr.push(encodeURIComponent(name) + "=" + encodeURIComponent(data[name]));
            }
            arr.push(("v=" + Math.random()).replace(".", ""));
            return arr.join("&");
        }
    </script>
    <title>JVM类加载信息</title>
</head>
<body>
<script type="text/javascript">
    var hostip = "localhost:8080";
    var osInfo;
    var d = new Date();
    var labels = ["","","","","","","","","","","",d.getMinutes()];
    var data = [
        {
            name : '总计',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#1f7e92',
            line_width:3
        },
        {
            name : '已加载',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#827fbf',
            line_width:3
        },{
            name : '已卸载',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#91aa51',
            line_width:3
        }
    ];
    $(function(){

        var chart = new iChart.LineBasic2D({
            id:'ichartjs2013',
            render : 'canvasDiv',
            data: data,
            title : 'JVM类加载信息',
            width : 800,
            height : 400,
            coordinate:{
                height:'90%',
                background_color:'#f6f9fa',
                scale:[{//配置自定义值轴
                    position:'left',//配置左值轴
                    listeners:{//配置事件
                        parseText:function(t,x,y){//设置解析值轴文本
                            return {text:t+" 个"}
                        }
                    }
                }]
            },
            sub_option:{
                hollow_inside:false,//设置一个点的亮色在外环的效果
                point_size:16
            },
            tip:{
                enable : true,
                listeners:{
                    //tip:提示框对象、name:数据名称、value:数据值、text:当前文本、i:数据点的索引
                    parseText:function(tip,name,value,text,i){
                        return "<span style='color:#005268;font-size:11px;font-weight:600;'>"+name+
                            "</span> <span style='color:#005268;font-size:20px;font-weight:600;'>"+value+"</span>";
                    }
                }
            },
            labels:["","","","","","","","","","","",d.getHours()+":"+d.getMinutes()]
        });
        chart.draw();

    });



    function getClassLoadInfo(){
        ajax({
            url: "http://"+hostip+"/getClassLoadInfo",
            type: "GET",
            needToken: false,
            dataType: "json",
            success: function (response) {

                var r = JSON.parse(response);
                var temp = data;

                temp[0].value.shift();
                temp[0].value.push(r.returnValue.totalLoadedClassCount);
                temp[1].value.shift();
                temp[1].value.push(r.returnValue.loadedClassCount);
                temp[2].value.shift();
                temp[2].value.push(r.returnValue.unloadedClassCount);

                document.getElementById("totalLoadedClassCount").innerHTML ="<p id='totalLoadedClassCount'>totalLoadedClassCount:"+r.returnValue.totalLoadedClassCount+"</p>";
                document.getElementById("loadedClassCount").innerHTML ="<p id='loadedClassCount'>loadedClassCount:"+r.returnValue.loadedClassCount+"</p>";
                document.getElementById("unloadedClassCount").innerHTML ="<p id='unloadedClassCount'>unloadedClassCount:"+r.returnValue.unloadedClassCount+"</p>";

                var chart = $.get('ichartjs2013');//根据ID获取图表对象
                chart.setUp();
                chart.load(temp);//载入新数据
            },
            fail: function (response) {
            }
        })
    }
    getClassLoadInfo();
    window.setInterval(getClassLoadInfo, 5000);

</script>
//JVM类加载信息
<div id='result'  style="float:left;height : 100px;width : 400px;">
    <p id="totalLoadedClassCount">totalLoadedClassCount:</p>
    <p id="loadedClassCount">loadedClassCount:</p>
    <p id="unloadedClassCount">unloadedClassCount:</p>

</div>





<div id='canvasDiv'  style="display:inline"></div>
</body>
</html>