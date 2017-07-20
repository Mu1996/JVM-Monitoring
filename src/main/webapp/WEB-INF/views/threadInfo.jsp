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
        if (options.needToken) {
            xhr.setRequestHeader("Token", getLoginToken());
        } else {
            xhr.setRequestHeader("Token", getLoginToken());
        }
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
<title>JVM系统进程Demo</title>
</head>
<body>
	<script type="text/javascript">
	var hostip = "localhost:8080";
	var osInfo;
	var d = new Date();
	var labels = ["","","","","","","","","","","",d.getMinutes()];
	var data = [
	        	{
	        		name : '活动的线程总数',
	        		value:[0,0,0,0,0,0,0,0,0,0,0,0],
	        		color:'#1f7e92',
	        		line_width:3
	        	}
	       ];
	$(function(){
		
		var chart = new iChart.LineBasic2D({
					id:'ichartjs2013',
					render : 'canvasDiv',
					data: data,
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
		chart.draw();
		
	});
	
	
	function getThreadInfo(){
		ajax({
            url: "http://"+hostip+"/Jvm/getThreadInfo",
            type: "GET",
            needToken: false,
            dataType: "json",
            success: function (response) {
            	
            	var r = JSON.parse(response);
            	var temp = data;
            	temp[0].value.shift();
            	temp[0].value.push(r.returnValue.threadCount);
            	
            	var chart = $.get('ichartjs2013');//根据ID获取图表对象
            	
            	
            	chart.load(temp);//载入新数据
            	
            	document.getElementById("threadCount").innerHTML ="<p id='threadCount'>仍活动进程个数:"+r.returnValue.threadCount+"</p>";
            	document.getElementById("peakThreadCount").innerHTML ="<p id='peakThreadCount'>峰值:"+r.returnValue.peakThreadCount+"</p>";
            	document.getElementById("totalStartedThreadCount").innerHTML ="<p id='totalStartedThreadCount'>线程总数（被创建并执行过的线程总数）:"+r.returnValue.totalStartedThreadCount+"</p>";
            	document.getElementById("daemonThreadCount").innerHTML ="<p id='daemonThreadCount'>当时仍活动的守护线程（daemonThread）总数:"+r.returnValue.daemonThreadCount+"个</p>";
            
            	
            },
            fail: function (response) {
            }
        })
	}
	getThreadInfo();
	window.setInterval(getThreadInfo, 5000);   

	
	</script>
	
	<div id='result'  style="float:left;height : 100px;width : 400px;">
	<p></p>
	//JVM系统进程Demo
	<p id="threadCount">仍活动进程个数:</p>
	<p id="peakThreadCount">峰值:</p>
	<p id="totalStartedThreadCount">线程总数（被创建并执行过的线程总数）:</p>
	<p id="daemonThreadCount">当时仍活动的守护线程（daemonThread）总数:</p>
	
	</div>
	
	<div id='canvasDiv'></div>
</body>
</html>