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
<title>远程服务器内存信息</title>
</head>
<body>
	<script type="text/javascript">
	var hostip = "localhost:8080";
	var osInfo;
	var d = new Date();
	var labels = ["","","","","","","","","","","",d.getMinutes()];
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
	$(function(){
		
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
		heap_chart.draw();
		non_heap_chart.draw();
		
		
	});
	
	function getMemoryInfo(){
		ajax({
            url: "http://"+hostip+"/getMemoryInfo",
            type: "GET",
            needToken: false,
            dataType: "json",
            success: function (response) {
            	
            	var r = JSON.parse(response);
            	var heap_temp = heap_data;
            	var non_heap_temp = non_heap_data;
            	
            	heap_temp[0].value.shift();
            	heap_temp[0].value.push(r.returnValue.heap.used);
            	non_heap_temp[0].value.shift();
            	non_heap_temp[0].value.push(r.returnValue.nonheap.used);
            	
            
            	document.getElementById("init").innerHTML ="<p id='init'>init:"+r.returnValue.heap.init+"M</p>";
            	document.getElementById("max").innerHTML ="<p id='max'>max:"+r.returnValue.heap.max+"M</p>";
            	document.getElementById("used").innerHTML ="<p id='used'>used:"+r.returnValue.heap.used+"M</p>";
            	document.getElementById("committed").innerHTML ="<p id='committed'>committed:"+r.returnValue.heap.committed+"M</p>";
            	document.getElementById("utilization").innerHTML ="<p id='utilization'>utilization:"+r.returnValue.heap.utilization+"%</p>";
            	
            	document.getElementById("non-heap-init").innerHTML ="<p id='non-heap-init'>init:"+r.returnValue.nonheap.init+"M</p>";
            	document.getElementById("non-heap-max").innerHTML ="<p id='non-heap-max'>max:"+r.returnValue.nonheap.max+"M</p>";
            	document.getElementById("non-heap-used").innerHTML ="<p id='non-heap-used'>used:"+r.returnValue.nonheap.used+"M</p>";
            	document.getElementById("non-heap-committed").innerHTML ="<p id='non-heap-committed'>committed:"+r.returnValue.nonheap.committed+"M</p>";
            	document.getElementById("non-heap-utilization").innerHTML ="<p id='non-heap-utilization'>utilization:"+r.returnValue.nonheap.utilization+"%</p>";
            	var heap_chart = $.get('heap_chart');//根据ID获取图表对象
            	var non_heap_chart = $.get('non_heap_chart');//根据ID获取图表对象
            	heap_chart.load(heap_temp);//载入新数据
            	non_heap_chart.load(non_heap_temp);//载入新数据
            },
            fail: function (response) {
            }
        })
	}
	
	getMemoryInfo();
	window.setInterval(getMemoryInfo, 5000);   
	
	</script>
	//heap堆使用情况
	<div id='result'  style="float:left;height : 100px;width : 400px;">
	<p id="name">name:heap堆</p>
	<p id="init">init:</p>
	<p id="max">max:</p>
	<p id="used">used:</p>
	<p id="committed">committed:</p>
	<p id="utilization">utilization:</p>
	</div>
	
		<div id='heap_chart_div'  ></div>
	
	
	//non-heap非堆使用情况
	<div id='result'  style="float:left;height : 100px;width : 400px;">
	<p id="non-heap-name">name:non-heap非堆</p>
	<p id="non-heap-init">init:</p>
	<p id="non-heap-max">max:</p>
	<p id="non-heap-used">used:</p>
	<p id="non-heap-committed">committed:</p>
	<p id="non-heap-utilization">utilization:</p>
	</div>
	
	
	
	<div id='non_heap_chart_div' ></div>
</body>
</html>