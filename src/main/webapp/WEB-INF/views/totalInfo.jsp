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

    var CodeCache_data = [
        {
            name : '当前(已使用)',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#1f7e92',
            line_width:3
        }
    ];

    var PSEdenSpace_data = [
        {
            name : '当前(已使用)',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#1f7e92',
            line_width:3
        }
    ];

    var PSOldGen_data = [
        {
            name : '当前(已使用)',
            value:[0,0,0,0,0,0,0,0,0,0,0,0],
            color:'#1f7e92',
            line_width:3
        }
    ]

    $(function(){

        var os_chart = new iChart.LineBasic2D({
            id:'os_chart',
            render : 'os_chart_div',
            data: os_data,
            title : '系统内存',
            width : 470,
            height : 200,
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
            width : 470,
            height : 200,
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
            width : 470,
            height : 200,
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
            width : 470,
            height : 200,
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
            width : 470,
            height : 200,
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

        var CodeCache_chart = new iChart.LineBasic2D({
            id:'CodeCache_chart',
            render : 'CodeCache_chart_div',
            data: CodeCache_data,
            title : '内存池CodeCache',
            width : 470,
            height : 200,
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
                            "</span> <span style='color:#005268;font-size:20px;font-weight:600;'>"+value+"</span>";
                    }
                }
            },
            labels:["","","","","","","","","","","",d.getHours()+":"+d.getMinutes()]
        });

        var PSEdenSpace_chart = new iChart.LineBasic2D({
            id:'PSEdenSpace_chart',
            render : 'PSEdenSpace_chart_div',
            data: PSEdenSpace_data,
            title : '内存池PSEdenSpace',
            width : 470,
            height : 200,
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
                            "</span> <span style='color:#005268;font-size:20px;font-weight:600;'>"+value+"</span>";
                    }
                }
            },
            labels:["","","","","","","","","","","",d.getHours()+":"+d.getMinutes()]
        });

        var PSOldGen_chart = new iChart.LineBasic2D({
            id:'PSOldGen_chart',
            render : 'PSOldGen_chart_div',
            data: PSOldGen_data,
            title : '内存池PSOldGen',
            width : 470,
            height : 200,
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
        CodeCache_chart.draw();
        PSEdenSpace_chart.draw();
        PSOldGen_chart.draw();


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
                var CodeCache_temp = CodeCache_data;
                var PSEdenSpace_temp = PSEdenSpace_data;
                var PSOldGen_temp = PSOldGen_data;

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

                CodeCache_temp[0].value.shift();
                CodeCache_temp[0].value.push(r.returnValue.CodeCache.used);
                PSEdenSpace_temp[0].value.shift();
                PSEdenSpace_temp[0].value.push(r.returnValue.PSEdenSpace.used);
                PSOldGen_temp[0].value.shift();
                PSOldGen_temp[0].value.push(r.returnValue.PSOldGen.used);


                document.getElementById("os_name").innerHTML ="<span id='os_name'>name:"+r.returnValue.osInfo.name+"</span><br>";
                document.getElementById("os_version").innerHTML ="<span id='os_version'>version:"+r.returnValue.osInfo.version+"</span><br>";
                document.getElementById("os_arch").innerHTML ="<span id='os_arch'>arch:"+r.returnValue.osInfo.arch+"</span><br>";
                document.getElementById("os_availableProcessors").innerHTML ="<span id='os_availableProcessors'>name:"+r.returnValue.osInfo.availableProcessors+"个</span><br>";
                document.getElementById("os_systemLoadAverage").innerHTML ="<span id='os_systemLoadAverage'>systemLoadAverage:"+r.returnValue.osInfo.systemLoadAverage+"</span><br>";
                document.getElementById("os_totalPhysicalMemorySize").innerHTML ="<span id='os_totalPhysicalMemorySize'>totalPhysicalMemorySize:"+r.returnValue.osInfo.totalPhysicalMemorySize+"M</span><br>";
                document.getElementById("os_usedPhysicalMemorySize").innerHTML ="<span id='os_usedPhysicalMemorySize'>usedPhysicalMemorySize:"+r.returnValue.osInfo.usedPhysicalMemorySize+"M</span><br>";
                document.getElementById("os_freePhysicalMemorySize").innerHTML ="<span id='os_freePhysicalMemorySize'>freePhysicalMemorySize:"+r.returnValue.osInfo.freePhysicalMemorySize+"M</span><br>";
                document.getElementById("os_totalSwapSpaceSize").innerHTML ="<span id='os_totalSwapSpaceSize'>totalSwapSpaceSize:"+r.returnValue.osInfo.totalSwapSpaceSize+"M</span><br>";
                document.getElementById("os_usedSwapSpaceSize").innerHTML ="<span id='os_usedSwapSpaceSize'>usedSwapSpaceSize:"+r.returnValue.osInfo.usedSwapSpaceSize+"M</span><br>";
                document.getElementById("os_freeSwapSpaceSize").innerHTML ="<span id='os_freeSwapSpaceSize'>freeSwapSpaceSize:"+r.returnValue.osInfo.freeSwapSpaceSize+"M</span><br>";
                document.getElementById("os_committedVirtualMemorySize").innerHTML ="<span id='os_committedVirtualMemorySize'>committedVirtualMemorySize:"+r.returnValue.osInfo.committedVirtualMemorySize+"M</span><br>";


                document.getElementById("heap_init").innerHTML ="<span id='heap_init'>init:"+r.returnValue.heap.init+"M</span><br>";
                document.getElementById("heap_max").innerHTML ="<span id='heap_max'>max:"+r.returnValue.heap.max+"M</span><br>";
                document.getElementById("heap_used").innerHTML ="<span id='heap_used'>used:"+r.returnValue.heap.used+"M</span><br>";
                document.getElementById("heap_committed").innerHTML ="<span id='heap_committed'>committed:"+r.returnValue.heap.committed+"M</span><br>";
                document.getElementById("heap_utilization").innerHTML ="<span id='heap_utilization'>utilization:"+r.returnValue.heap.utilization+"%</span><br>";

                document.getElementById("non-heap-init").innerHTML ="<span id='non-heap-init'>init:"+r.returnValue.nonheap.init+"M</span><br>";
                document.getElementById("non-heap-max").innerHTML ="<span id='non-heap-max'>max:"+r.returnValue.nonheap.max+"M</span><br>";
                document.getElementById("non-heap-used").innerHTML ="<span id='non-heap-used'>used:"+r.returnValue.nonheap.used+"M</span><br>";
                document.getElementById("non-heap-committed").innerHTML ="<span id='non-heap-committed'>committed:"+r.returnValue.nonheap.committed+"M</span><br>";
                document.getElementById("non-heap-utilization").innerHTML ="<span id='non-heap-utilization'>utilization:"+r.returnValue.nonheap.utilization+"%</span><br>";

                document.getElementById("threadCount").innerHTML ="<span id='threadCount'>仍活动进程个数:"+r.returnValue.threadInfo.threadCount+"</span><br>";
                document.getElementById("peakThreadCount").innerHTML ="<span id='peakThreadCount'>峰值:"+r.returnValue.threadInfo.peakThreadCount+"</span><br>";
                document.getElementById("totalStartedThreadCount").innerHTML ="<span id='totalStartedThreadCount'>线程总数（被创建并执行过的线程总数）:"+r.returnValue.threadInfo.totalStartedThreadCount+"</span><br>";
                document.getElementById("daemonThreadCount").innerHTML ="<span id='daemonThreadCount'>当时仍活动的守护线程（daemonThread）总数:"+r.returnValue.threadInfo.daemonThreadCount+"个</span><br>";

                document.getElementById("totalLoadedClassCount").innerHTML ="<span id='totalLoadedClassCount'>totalLoadedClassCount:"+r.returnValue.classLoadInfo.totalLoadedClassCount+"</span><br>";
                document.getElementById("loadedClassCount").innerHTML ="<span id='loadedClassCount'>loadedClassCount:"+r.returnValue.classLoadInfo.loadedClassCount+"</span><br>";
                document.getElementById("unloadedClassCount").innerHTML ="<span id='unloadedClassCount'>unloadedClassCount:"+r.returnValue.classLoadInfo.unloadedClassCount+"</span><br>";


                var os_chart = $.get('os_chart');//根据ID获取图表对象
                var heap_chart = $.get('heap_chart');//根据ID获取图表对象
                var non_heap_chart = $.get('non_heap_chart');//根据ID获取图表对象
                var thread_chart = $.get('thread_chart');//根据ID获取图表对象
                var classLoad_chart = $.get('classLoad_chart');//根据ID获取图表对象
                var CodeCache_chart = $.get('CodeCache_chart');//根据ID获取图表对象
                var PSEdenSpace_chart = $.get('PSEdenSpace_chart');//根据ID获取图表对象
                var PSOldGen_chart = $.get('PSOldGen_chart');//根据ID获取图表对象
                os_chart.load(os_temp);//载入新数据
                heap_chart.load(heap_temp);//载入新数据
                non_heap_chart.load(non_heap_temp);//载入新数据
                thread_chart.load(thread_temp);//载入新数据
                classLoad_chart.load(classLoad_temp);//载入新数据
                CodeCache_chart.load(CodeCache_temp);//载入新数据
                PSEdenSpace_chart.load(PSEdenSpace_temp);//载入新数据
                PSOldGen_chart.load(PSOldGen_temp);//载入新数据
            },
            fail: function (response) {
            }
        })
    }

    updateInfo();
    window.setInterval(updateInfo, 5000);

</script>


<div id='osinfo'  style="float:left;width : auto;">
    //JVM系统内存Demo<br>
    <span id="os_name">name:</span>
    <span id="os_version">version:</span>
    <span id="os_arch">arch:</span>
    <span id="os_availableProcessors">availableProcessors:</span>
    <span id="os_systemLoadAverage">systemLoadAverage:</span>
    <span id="os_totalPhysicalMemorySize">totalPhysicalMemorySize:</span>
    <span id="os_usedPhysicalMemorySize">usedPhysicalMemorySize:</span>
    <span id="os_freePhysicalMemorySize">freePhysicalMemorySize:</span>
    <span id="os_totalSwapSpaceSize">totalSwapSpaceSize:</span>
    <span id="os_usedSwapSpaceSize">usedSwapSpaceSize:</span>
    <span id="os_freeSwapSpaceSize">freeSwapSpaceSize:</span>
    <span id="os_committedVirtualMemorySize">committedVirtualMemorySize:</span>
</div>


<div id='heap'  style="float:left;width : auto;">
    //heap堆使用情况<br>
    <span id="heap_name">name:heap堆</span>
    <span id="heap_init">init:</span>
    <span id="heap_max">max:</span>
    <span id="heap_used">used:</span>
    <span id="heap_committed">committed:</span>
    <span id="heap_utilization">utilization:</span>
</div>




<div id='nonheap'  style="float:left;width : auto;">
    //non-heap非堆使用情况<br>
    <span id="non-heap-name">name:non-heap非堆</span>
    <span id="non-heap-init">init:</span>
    <span id="non-heap-max">max:</span>
    <span id="non-heap-used">used:</span>
    <span id="non-heap-committed">committed:</span>
    <span id="non-heap-utilization">utilization:</span>
</div>

<div id='thread'  style="float:left;width : auto;">
    <span></span>
    //JVM系统进程Demo<br>
    <span id="threadCount">仍活动进程个数:</span>
    <span id="peakThreadCount">峰值:</span>
    <span id="totalStartedThreadCount">线程总数（被创建并执行过的线程总数）:</span>
    <span id="daemonThreadCount">当时仍活动的守护线程（daemonThread）总数:</span>
</div>


<div id='classLoad'  style="float:left;width : auto;">
    //JVM类加载信息<br>
    <span id="totalLoadedClassCount">totalLoadedClassCount:</span>
    <span id="loadedClassCount">loadedClassCount:</span>
    <span id="unloadedClassCount">unloadedClassCount:</span>
</div>

<div id='os_chart_div' style="clear:both;float:left;width : auto;" ></div>

<div id='heap_chart_div' style="float:left;width : auto;" ></div>

<div id='non_heap_chart_div' style="float:left;width : auto;"></div>

<div id='thread_chart_div' style="float:left;width : auto;"></div>

<div id='classLoad_chart_div' style="float:left;width : auto;"></div>

<div id='CodeCache_chart_div' style="float:left;width : auto;"></div>
<div id='PSEdenSpace_chart_div' style="float:left;width : auto;"></div>
<div id='PSOldGen_chart_div' style="float:left;width : auto;"></div>

</body>
</html>