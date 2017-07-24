<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 2017/7/24
  Time: 15:37
  To change this template use File | Settings | File Templates.
--%>
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
                xhr.setRequestheaper("Content-Type", "application/x-www-form-urlencoded");

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
    <title>远程服务器汇总图</title>
</head>
<body>
<script type="text/javascript">
    var hostip = "localhost:8080";
    var d = new Date();
    var labels = ["","","","","","","","","","","",d.getMinutes()];
    var os_data = [
        {
            name : '已用物理内存(M)',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#1f7e92',
            line_width:3
        },
        {
            name : '剩余物理内存(M)',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#827fbf',
            line_width:3
        },{
            name : '提交的虚拟内存',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#91aa51',
            line_width:3
        }
    ];

    var heap_data = [
        {
            name : '当前(已使用)',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#1f7e92',
            line_width:3
        }
    ];

    var non_heap_data = [
        {
            name : '当前(已使用)',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#f68f70',
            line_width:3
        }
    ];

    var thread_data = [
        {
            name : '活动的线程总数',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#1f7e92',
            line_width:3
        }
    ];

    var classLoad_data = [
        {
            name : '已加载',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#827fbf',
            line_width:3
        }
    ];

    $(function(){

        var os_chart = new iChart.LineBasic2D({
            id:'os_chart',
            render : 'os_chart_div',
            data: os_data,
            title : '系统内存',
            width : 800,
            height : 400,
            coordinate:{
                height:'90%',
                background_color:'#f6f9fa',
                scale:[{//配置自定义值轴
                    position:'left',//配置左值轴
                    listeners:{//配置事件
                        parseText:function(t,x,y){//设置解析值轴文本
                            return {text:t+" M"}
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
                            "</span> <span style='color:#005268;font-size:20px;font-weight:600;'>"+value+"M</span>";
                    }
                }
            },
            labels:["","","","","","","","","","","",d.getHours()+":"+d.getMinutes()]
        });

        var heap_chart = new iChart.LineBasic2D({
            id:'heap_chart',
            render : 'heap_chart_div',
            data: heap_data,
            title : 'heap堆',
            width : 800,
            height : 400,
            coordinate:{
                height:'90%',
                background_color:'#f6f9fa',
                scale:[{//配置自定义值轴
                    position:'left',//配置左值轴
                    listeners:{//配置事件
                        parseText:function(t,x,y){//设置解析值轴文本
                            return {text:t+" M"}
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
                            "</span> <span style='color:#005268;font-size:20px;font-weight:600;'>"+value+"M</span>";
                    }
                }
            },
            labels:["","","","","","","","","","","",d.getHours()+":"+d.getMinutes()]
        });

        var non_heap_chart = new iChart.LineBasic2D({
            id:'non_heap_chart',
            render : 'non_heap_chart_div',
            data: non_heap_data,
            title : 'non-heap非堆',
            width : 800,
            height : 400,
            coordinate:{
                height:'90%',
                background_color:'#f6f9fa',
                scale:[{//配置自定义值轴
                    position:'left',//配置左值轴
                    listeners:{//配置事件
                        parseText:function(t,x,y){//设置解析值轴文本
                            return {text:t+" M"}
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
                            "</span> <span style='color:#005268;font-size:20px;font-weight:600;'>"+value+"M</span>";
                    }
                }
            },
            labels:["","","","","","","","","","","",d.getHours()+":"+d.getMinutes()]
        });

        var thread_chart = new iChart.LineBasic2D({
            id:'thread_chart',
            render : 'thread_chart_div',
            data: thread_data,
            title : '线程',
            width : 800,
            height : 400,
            coordinate:{height:'90%',background_color:'#f6f9fa'},
            sub_option:{
                hollow_inside:false,//设置一个点的亮色在外环的效果
                point_size:16,
                scale:[{//配置自定义值轴
                    position:'left',//配置左值轴
                    listeners:{//配置事件
                        parseText:function(t,x,y){//设置解析值轴文本
                            return {text:t+" 个"}
                        }
                    }
                }]
            },
            tip:{
                enable : true,
                listeners:{
                    //tip:提示框对象、name:数据名称、value:数据值、text:当前文本、i:数据点的索引
                    parseText:function(tip,name,value,text,i){
                        return "<span style='color:#005268;font-size:11px;font-weight:600;'>"+name+
                            "</span> <span style='color:#005268;font-size:20px;font-weight:600;'>"+value+"M</span>";
                    }
                }
            },
            labels:["","","","","","","","","","","",d.getHours()+":"+d.getMinutes()]
        });

        var classLoad_chart = new iChart.LineBasic2D({
            id:'classLoad_chart',
            render : 'classLoad_chart_div',
            data: classLoad_data,
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

        os_chart.draw();
        heap_chart.draw();
        non_heap_chart.draw();
        thread_chart.draw();
        classLoad_chart.draw();


    });

    function updateInfo(){
        ajax({
            url: "http://"+hostip+"/getAllInfo",
            type: "GET",
            needToken: false,
            dataType: "json",
            success: function (response) {

                var r = JSON.parse(response);
                var os_temp = os_data;
                var heap_temp = heap_data;
                var non_heap_temp = non_heap_data;
                var thread_temp = thread_data;
                var classLoad_temp = classLoad_data;

                os_temp[0].value.shift();
                os_temp[0].value.push(r.returnValue.osInfo.usedPhysicalMemorySize);
                os_temp[1].value.shift();
                os_temp[1].value.push(r.returnValue.osInfo.freePhysicalMemorySize);
                os_temp[2].value.shift();
                os_temp[2].value.push(r.returnValue.osInfo.committedVirtualMemorySize);
                heap_temp[0].value.shift();
                heap_temp[0].value.push(r.returnValue.heap.used);
                non_heap_temp[0].value.shift();
                non_heap_temp[0].value.push(r.returnValue.nonheap.used);
                thread_temp[0].value.shift();
                thread_temp[0].value.push(r.returnValue.threadInfo.threadCount);
                classLoad_temp[0].value.shift();
                classLoad_temp[0].value.push(r.returnValue.classLoadInfo.loadedClassCount);

                document.getElementById("os_name").innerHTML ="<p id='os_name'>name:"+r.returnValue.osInfo.name+"</p>";
                document.getElementById("os_version").innerHTML ="<p id='os_version'>version:"+r.returnValue.osInfo.version+"</p>";
                document.getElementById("os_arch").innerHTML ="<p id='os_arch'>arch:"+r.returnValue.osInfo.arch+"</p>";
                document.getElementById("os_availableProcessors").innerHTML ="<p id='os_availableProcessors'>name:"+r.returnValue.osInfo.availableProcessors+"个</p>";
                document.getElementById("os_systemLoadAverage").innerHTML ="<p id='os_systemLoadAverage'>systemLoadAverage:"+r.returnValue.osInfo.systemLoadAverage+"</p>";
                document.getElementById("os_totalPhysicalMemorySize").innerHTML ="<p id='os_totalPhysicalMemorySize'>totalPhysicalMemorySize:"+r.returnValue.osInfo.totalPhysicalMemorySize+"M</p>";
                document.getElementById("os_usedPhysicalMemorySize").innerHTML ="<p id='os_usedPhysicalMemorySize'>usedPhysicalMemorySize:"+r.returnValue.osInfo.usedPhysicalMemorySize+"M</p>";
                document.getElementById("os_freePhysicalMemorySize").innerHTML ="<p id='os_freePhysicalMemorySize'>freePhysicalMemorySize:"+r.returnValue.osInfo.freePhysicalMemorySize+"M</p>";
                document.getElementById("os_totalSwapSpaceSize").innerHTML ="<p id='os_totalSwapSpaceSize'>totalSwapSpaceSize:"+r.returnValue.osInfo.totalSwapSpaceSize+"M</p>";
                document.getElementById("os_usedSwapSpaceSize").innerHTML ="<p id='os_usedSwapSpaceSize'>usedSwapSpaceSize:"+r.returnValue.osInfo.usedSwapSpaceSize+"M</p>";
                document.getElementById("os_freeSwapSpaceSize").innerHTML ="<p id='os_freeSwapSpaceSize'>freeSwapSpaceSize:"+r.returnValue.osInfo.freeSwapSpaceSize+"M</p>";
                document.getElementById("os_committedVirtualMemorySize").innerHTML ="<p id='os_committedVirtualMemorySize'>committedVirtualMemorySize:"+r.returnValue.osInfo.committedVirtualMemorySize+"M</p>";


                document.getElementById("heap_init").innerHTML ="<p id='heap_init'>init:"+r.returnValue.heap.init+"M</p>";
                document.getElementById("heap_max").innerHTML ="<p id='heap_max'>max:"+r.returnValue.heap.max+"M</p>";
                document.getElementById("heap_used").innerHTML ="<p id='heap_used'>used:"+r.returnValue.heap.used+"M</p>";
                document.getElementById("heap_committed").innerHTML ="<p id='heap_committed'>committed:"+r.returnValue.heap.committed+"M</p>";
                document.getElementById("heap_utilization").innerHTML ="<p id='heap_utilization'>utilization:"+r.returnValue.heap.utilization+"%</p>";

                document.getElementById("non-heap-init").innerHTML ="<p id='non-heap-init'>init:"+r.returnValue.nonheap.init+"M</p>";
                document.getElementById("non-heap-max").innerHTML ="<p id='non-heap-max'>max:"+r.returnValue.nonheap.max+"M</p>";
                document.getElementById("non-heap-used").innerHTML ="<p id='non-heap-used'>used:"+r.returnValue.nonheap.used+"M</p>";
                document.getElementById("non-heap-committed").innerHTML ="<p id='non-heap-committed'>committed:"+r.returnValue.nonheap.committed+"M</p>";
                document.getElementById("non-heap-utilization").innerHTML ="<p id='non-heap-utilization'>utilization:"+r.returnValue.nonheap.utilization+"%</p>";

                document.getElementById("threadCount").innerHTML ="<p id='threadCount'>仍活动进程个数:"+r.returnValue.threadInfo.threadCount+"</p>";
                document.getElementById("peakThreadCount").innerHTML ="<p id='peakThreadCount'>峰值:"+r.returnValue.threadInfo.peakThreadCount+"</p>";
                document.getElementById("totalStartedThreadCount").innerHTML ="<p id='totalStartedThreadCount'>线程总数（被创建并执行过的线程总数）:"+r.returnValue.threadInfo.totalStartedThreadCount+"</p>";
                document.getElementById("daemonThreadCount").innerHTML ="<p id='daemonThreadCount'>当时仍活动的守护线程（daemonThread）总数:"+r.returnValue.threadInfo.daemonThreadCount+"个</p>";

                document.getElementById("totalLoadedClassCount").innerHTML ="<p id='totalLoadedClassCount'>totalLoadedClassCount:"+r.returnValue.classLoadInfo.totalLoadedClassCount+"</p>";
                document.getElementById("loadedClassCount").innerHTML ="<p id='loadedClassCount'>loadedClassCount:"+r.returnValue.classLoadInfo.loadedClassCount+"</p>";
                document.getElementById("unloadedClassCount").innerHTML ="<p id='unloadedClassCount'>unloadedClassCount:"+r.returnValue.classLoadInfo.unloadedClassCount+"</p>";


                var os_chart = $.get('os_chart');//根据ID获取图表对象
                var heap_chart = $.get('heap_chart');//根据ID获取图表对象
                var non_heap_chart = $.get('non_heap_chart');//根据ID获取图表对象
                var thread_chart = $.get('thread_chart');//根据ID获取图表对象
                var classLoad_chart = $.get('classLoad_chart');//根据ID获取图表对象
                os_chart.load(os_temp);//载入新数据
                heap_chart.load(heap_temp);//载入新数据
                non_heap_chart.load(non_heap_temp);//载入新数据
                thread_chart.load(thread_temp);//载入新数据
                classLoad_chart.load(classLoad_temp);//载入新数据
            },
            fail: function (response) {
            }
        })
    }

    updateInfo();
    window.setInterval(updateInfo, 5000);

</script>

//JVM系统内存Demo
<div id='osinfo'  style="float:left;height : 100px;width : 400px;">
    <p id="os_name">name:</p>
    <p id="os_version">version:</p>
    <p id="os_arch">arch:</p>
    <p id="os_availableProcessors">availableProcessors:</p>
    <p id="os_systemLoadAverage">systemLoadAverage:</p>
    <p id="os_totalPhysicalMemorySize">totalPhysicalMemorySize:</p>
    <p id="os_usedPhysicalMemorySize">usedPhysicalMemorySize:</p>
    <p id="os_freePhysicalMemorySize">freePhysicalMemorySize:</p>
    <p id="os_totalSwapSpaceSize">totalSwapSpaceSize:</p>
    <p id="os_usedSwapSpaceSize">usedSwapSpaceSize:</p>
    <p id="os_freeSwapSpaceSize">freeSwapSpaceSize:</p>
    <p id="os_committedVirtualMemorySize">committedVirtualMemorySize:</p>
</div>
<div id='os_chart_div'  ></div>
<p>////</p>
<div></div>
<p> ////</p>
//heap堆使用情况
<div id='heap'  style="float:left;height : 100px;width : 400px;">
    <p id="heap_name">name:heap堆</p>
    <p id="heap_init">init:</p>
    <p id="heap_max">max:</p>
    <p id="heap_used">used:</p>
    <p id="heap_committed">committed:</p>
    <p id="heap_utilization">utilization:</p>
</div>

<div id='heap_chart_div'  ></div>


//non-heap非堆使用情况
<div id='nonheap'  style="float:left;height : 100px;width : 400px;">
    <p id="non-heap-name">name:non-heap非堆</p>
    <p id="non-heap-init">init:</p>
    <p id="non-heap-max">max:</p>
    <p id="non-heap-used">used:</p>
    <p id="non-heap-committed">committed:</p>
    <p id="non-heap-utilization">utilization:</p>
</div>
<div id='non_heap_chart_div' ></div>

<div id='thread'  style="float:left;height : 100px;width : 400px;">
    <p></p>
    //JVM系统进程Demo
    <p id="threadCount">仍活动进程个数:</p>
    <p id="peakThreadCount">峰值:</p>
    <p id="totalStartedThreadCount">线程总数（被创建并执行过的线程总数）:</p>
    <p id="daemonThreadCount">当时仍活动的守护线程（daemonThread）总数:</p>

</div>

<div id='thread_chart_div'></div>

//JVM类加载信息
<div id='classLoad'  style="float:left;height : 100px;width : 400px;">
    <p id="totalLoadedClassCount">totalLoadedClassCount:</p>
    <p id="loadedClassCount">loadedClassCount:</p>
    <p id="unloadedClassCount">unloadedClassCount:</p>

</div>
<div id='classLoad_chart_div'></div>

</body>
</html>