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
<title>远程服务器系统信息</title>
</head>
<body>
	<script type="text/javascript">
	var hostip = "localhost:8080";
	var osInfo;
	var d = new Date();
	var labels = ["","","","","","","","","","","",d.getMinutes()];
	var data = [
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
	$(function(){
		
		var chart = new iChart.LineBasic2D({
					id:'ichartjs2013',
					render : 'canvasDiv',
					data: data,
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
		chart.draw();
		
	});
	
	
	
	function getOSInfo(){
		ajax({
            url: "http://"+hostip+"/Jvm/getOSInfo",
            type: "GET",
            needToken: false,
            dataType: "json",
            success: function (response) {
            	
            	var r = JSON.parse(response);
            	var temp = data;
            	
            	temp[0].value.shift();
            	temp[0].value.push(r.returnValue.usedPhysicalMemorySize);
            	temp[1].value.shift();
            	temp[1].value.push(r.returnValue.freePhysicalMemorySize);
            	temp[2].value.shift();
            	temp[2].value.push(r.returnValue.committedVirtualMemorySize);
            
            	document.getElementById("name").innerHTML ="<p id='name'>name:"+r.returnValue.name+"</p>";
            	document.getElementById("version").innerHTML ="<p id='version'>version:"+r.returnValue.version+"</p>";
            	document.getElementById("arch").innerHTML ="<p id='arch'>arch:"+r.returnValue.arch+"</p>";
            	document.getElementById("availableProcessors").innerHTML ="<p id='availableProcessors'>name:"+r.returnValue.availableProcessors+"个</p>";
            	document.getElementById("systemLoadAverage").innerHTML ="<p id='systemLoadAverage'>systemLoadAverage:"+r.returnValue.systemLoadAverage+"</p>";
            	document.getElementById("totalPhysicalMemorySize").innerHTML ="<p id='totalPhysicalMemorySize'>totalPhysicalMemorySize:"+r.returnValue.totalPhysicalMemorySize+"M</p>";
            	document.getElementById("usedPhysicalMemorySize").innerHTML ="<p id='usedPhysicalMemorySize'>usedPhysicalMemorySize:"+r.returnValue.usedPhysicalMemorySize+"M</p>";
            	document.getElementById("freePhysicalMemorySize").innerHTML ="<p id='freePhysicalMemorySize'>freePhysicalMemorySize:"+r.returnValue.freePhysicalMemorySize+"M</p>";
            	document.getElementById("totalSwapSpaceSize").innerHTML ="<p id='totalSwapSpaceSize'>totalSwapSpaceSize:"+r.returnValue.totalSwapSpaceSize+"M</p>";
            	document.getElementById("usedSwapSpaceSize").innerHTML ="<p id='usedSwapSpaceSize'>usedSwapSpaceSize:"+r.returnValue.usedSwapSpaceSize+"M</p>";
            	document.getElementById("freeSwapSpaceSize").innerHTML ="<p id='freeSwapSpaceSize'>freeSwapSpaceSize:"+r.returnValue.freeSwapSpaceSize+"M</p>";
            	document.getElementById("committedVirtualMemorySize").innerHTML ="<p id='committedVirtualMemorySize'>committedVirtualMemorySize:"+r.returnValue.committedVirtualMemorySize+"M</p>";
            	
            	var chart = $.get('ichartjs2013');//根据ID获取图表对象
            	chart.setUp();
            	chart.load(temp);//载入新数据
            },
            fail: function (response) {
            }
        })
	}
	getOSInfo();
	window.setInterval(getOSInfo, 5000);   
	
	</script>
	//JVM系统内存Demo
	<div id='result'  style="float:left;height : 100px;width : 400px;">
	<p id="name">name:</p>
	<p id="version">version:</p>
	<p id="arch">arch:</p>
	<p id="availableProcessors">availableProcessors:</p>
	<p id="systemLoadAverage">systemLoadAverage:</p>
	<p id="totalPhysicalMemorySize">totalPhysicalMemorySize:</p>
	<p id="usedPhysicalMemorySize">usedPhysicalMemorySize:</p>
	<p id="freePhysicalMemorySize">freePhysicalMemorySize:</p>
	<p id="totalSwapSpaceSize">totalSwapSpaceSize:</p>
	<p id="usedSwapSpaceSize">usedSwapSpaceSize:</p>
	<p id="freeSwapSpaceSize">freeSwapSpaceSize:</p>
	<p id="committedVirtualMemorySize">committedVirtualMemorySize:</p>
	</div>
	
	
	
	
	
	<div id='canvasDiv'  style="display:inline"></div>
</body>
</html>