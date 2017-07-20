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
<title>Insert title here</title>
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
	        	},
	        	{
	        		name : '峰值',
	        		value:[0,0,0,0,0,0,0,0,0,0,0,0],
	        		color:'#827fbf',
	        		line_width:3
	        	},
	        	{
	        		name : '线程总数',
	        		value:[0,0,0,0,0,0,0,0,0,0,0,0],
	        		color:'#e4be4d',
	        		line_width:3
	        	},
	        	{
	        		name : '当初仍活动的守护线程',
	        		value:[0,0,0,0,0,0,0,0,0,0,0,0],
	        		color:'#a14545',
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
						point_size:16
					},
					labels:["","","","","","","","","","","",d.getHours()+":"+d.getMinutes()]
				});
		chart.draw();
		chart.setUp();
	});
	
	window.setInterval(getOSInfo, 5000);   
	
	function getOSInfo(){
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
            	temp[1].value.shift();
            	temp[1].value.push(r.returnValue.peakThreadCount);
            	temp[2].value.shift();
            	temp[2].value.push(r.returnValue.totalStartedThreadCount);
            	temp[3].value.shift();
            	temp[3].value.push(r.returnValue.daemonThreadCount);
            	var chart = $.get('ichartjs2013');//根据ID获取图表对象
            	chart.load(temp);//载入新数据
            },
            fail: function (response) {
            }
        })
	}

//创建随机数据源				
var create = function (){
		var f = function(){return Math.floor(Math.random()*40)+10;},opacity = 0.8	
		return function(){
			return [
		        	{name : 'Jan-Mar',value : f(),color:$.toRgba('#827fbf',opacity)},
		        	{name : 'Apr-Jun',value : f(),color:$.toRgba('#e4be4d',opacity)},
		        	{name : 'Jul-Sep',value : f(),color:$.toRgba('#91aa51',opacity)},
		        	{name : 'Oct-Dec',value : f(),color:$.toRgba('#a14545',opacity)}
	  	 	]
	}
}();	
	
function load(){
	var chart = $.get('ichartjs2013');//根据ID获取图表对象
	chart.load(getOSInfo());//载入新数据
}
	</script>
	//Html代码
	<div id='canvasDiv'></div>
</body>
</html>