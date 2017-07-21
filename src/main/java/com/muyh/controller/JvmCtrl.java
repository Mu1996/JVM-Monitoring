package com.muyh.controller;

import java.util.HashMap;
import java.util.Map;

import com.muyh.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.muyh.service.JvmInfoService;

@Controller
@RequestMapping(value = "/")
public class JvmCtrl {
	
	@Autowired
	JvmInfoService jvmInfoService;
	
	@RequestMapping(value = "/getTotalPage", method = RequestMethod.GET)
    public String getTotalPage(ModelMap model) {
		
        return "totalPage";
    }
	
	@RequestMapping(value = "/getOSPage", method = RequestMethod.GET)
	public String getOSPage(ModelMap model) {
		
        return "osInfo";
    }
	
	@RequestMapping(value = "/getThreadPage", method = RequestMethod.GET)
    public String getThreadPage(ModelMap model) {
		
        return "threadInfo";
    }
	
	@RequestMapping(value = "/getMemoryPage", method = RequestMethod.GET)
    public String getMemoryPage(ModelMap model) {
		
        return "memoryInfo";
    }

	@RequestMapping(value = "/getClassLoadPage", method = RequestMethod.GET)
	public String getClassLoadPage(ModelMap model) {

		return "classLoadInfo";
	}
	
	@ResponseBody
	@RequestMapping(value = "/getAllInfo", method = RequestMethod.GET)
    public RES getAllInfo(ModelMap model) {
			
		HashMap<String, Object> allInfo = jvmInfoService.getAllInfo("service:jmx:rmi:///jndi/rmi://118.89.203.197:60001/jmxrmi");
		RES res = new RES();
		res.code = 0;
		res.returnValue = allInfo;
		res.errorReason = "";
		
        return res;
    }
	
	@ResponseBody
	@RequestMapping(value = "/getOSInfo", method = RequestMethod.GET)
    public RES getOSInfo(ModelMap model) {
			
		OSInfo osInfo = jvmInfoService.getOSInfo("service:jmx:rmi:///jndi/rmi://118.89.203.197:60001/jmxrmi");
		RES res = new RES();
		res.code = 0;
		res.returnValue = osInfo;
		res.errorReason = "";
		
        return res;
    }
	
	@ResponseBody
	@RequestMapping(value = "/getMemoryInfo", method = RequestMethod.GET)
    public RES getMemoryInfo(ModelMap model) {
			
		Map<String,MemoryInfo> memory = jvmInfoService.getMemoryInfo("service:jmx:rmi:///jndi/rmi://118.89.203.197:60001/jmxrmi");
		RES res = new RES();
		res.code = 0;
		res.returnValue = memory;
		res.errorReason = "";
		
        return res;
    }
	
	@ResponseBody
	@RequestMapping(value = "/getThreadInfo", method = RequestMethod.GET)
    public RES getThreadInfo(ModelMap model) {
			
		JVMThreadInfo thread = jvmInfoService.getThreadInfo("service:jmx:rmi:///jndi/rmi://118.89.203.197:60001/jmxrmi");
		RES res = new RES();
		res.code = 0;
		res.returnValue = thread;
		res.errorReason = "";
		
        return res;
    }

	@ResponseBody
	@RequestMapping(value = "/getClassLoadInfo", method = RequestMethod.GET)
	public RES getClassLoadInfo(ModelMap model) {

		ClassLoadInfo classLoad = jvmInfoService.getClassLoadInfo("service:jmx:rmi:///jndi/rmi://118.89.203.197:60001/jmxrmi");
		RES res = new RES();
		res.code = 0;
		res.returnValue = classLoad;
		res.errorReason = "";

		return res;
	}
}
