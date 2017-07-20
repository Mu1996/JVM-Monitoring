package com.muyh.service;

import java.io.IOException;
import java.lang.management.ClassLoadingMXBean;
import java.lang.management.CompilationMXBean;
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.management.MemoryUsage;
import java.lang.management.OperatingSystemMXBean;
import java.lang.management.RuntimeMXBean;
import java.lang.management.ThreadMXBean;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.management.AttributeNotFoundException;
import javax.management.InstanceNotFoundException;
import javax.management.MBeanException;
import javax.management.MBeanServerConnection;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.ReflectionException;
import javax.management.openmbean.CompositeDataSupport;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;

import org.springframework.stereotype.Service;

import com.muyh.model.ClassLoadInfo;
import com.muyh.model.JVMThreadInfo;
import com.muyh.model.MemoryInfo;
import com.muyh.model.OSInfo;
import com.muyh.model.RuntimeInfo;

@Service
public class JvmInfoService {
	
	static final long MB = 1024 * 1024;  
	
	// 获取服务器基本信息
	public OSInfo getOSInfo(String url) {
		try {
			JMXServiceURL serviceURL = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://118.89.203.197:12312/jmxrmi");
//			JMXServiceURL serviceURL = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://118.89.203.197:60001/jmxrmi");
			JMXConnector conn = JMXConnectorFactory.connect(serviceURL);
			MBeanServerConnection mbs=conn.getMBeanServerConnection();  
			
			//操作系统信息
			OperatingSystemMXBean opMXbean =   
			        ManagementFactory.newPlatformMXBeanProxy(mbs,                 
			        ManagementFactory.OPERATING_SYSTEM_MXBEAN_NAME, OperatingSystemMXBean.class);
			OSInfo osInfo = new OSInfo();
			osInfo.setArch(opMXbean.getArch());
			osInfo.setName(opMXbean.getName());
			osInfo.setVersion(opMXbean.getVersion());
			osInfo.setAvailableProcessors(opMXbean.getAvailableProcessors());
			osInfo.setSystemLoadAverage(opMXbean.getSystemLoadAverage());
			
			CompilationMXBean compilation = ManagementFactory.newPlatformMXBeanProxy  
			        (mbs,ManagementFactory.COMPILATION_MXBEAN_NAME, CompilationMXBean.class);
			if(compilation.isCompilationTimeMonitoringSupported()){  
//	            System.out.println("总编译时间："+compilation.getTotalCompilationTime()+"秒");  
	        }  
			try {
				ObjectName objectName = new ObjectName("java.lang:type=OperatingSystem");
				try {
					
					long totalPhysicalMemorySize = (long)mbs.getAttribute(objectName,"TotalPhysicalMemorySize");
		            long freePhysicalMemorySize = (long) mbs.getAttribute(objectName,"FreePhysicalMemorySize");
		            long usedPhysicalMemorySize =totalPhysicalMemorySize - freePhysicalMemorySize;  
		            osInfo.setTotalPhysicalMemorySize(totalPhysicalMemorySize/MB);  
		            osInfo.setUsedPhysicalMemorySize(usedPhysicalMemorySize/MB);
		            osInfo.setFreePhysicalMemorySize(freePhysicalMemorySize/MB);
		            
		              
		            long totalSwapSpaceSize = (long)mbs.getAttribute(objectName,"TotalSwapSpaceSize");  
		            long freeSwapSpaceSize = (long)mbs.getAttribute(objectName,"FreeSwapSpaceSize");
		            long usedSwapSpaceSize = totalSwapSpaceSize - freeSwapSpaceSize;  
		            osInfo.setTotalSwapSpaceSize(totalSwapSpaceSize/MB);  
		            osInfo.setUsedSwapSpaceSize(usedSwapSpaceSize/MB);
		            osInfo.setFreeSwapSpaceSize(freeSwapSpaceSize/MB);
		            
		            
		            long committedVirtualMemorySize = (long)mbs.getAttribute(objectName,"CommittedVirtualMemorySize");  
		            osInfo.setCommittedVirtualMemorySize(committedVirtualMemorySize/MB);

		          
				} catch (AttributeNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InstanceNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (MBeanException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (ReflectionException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}  
	          
			} catch (MalformedObjectNameException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        
	        
	        return osInfo;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;     
    }
	
	// 获取内存信息
	public Map<String,MemoryInfo> getMemoryInfo(String url) {
		try {
			JMXServiceURL serviceURL = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://localhost:12312/jmxrmi");
//			JMXServiceURL serviceURL = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://118.89.203.197:60001/jmxrmi");
			JMXConnector conn = JMXConnectorFactory.connect(serviceURL);
			MBeanServerConnection mbs=conn.getMBeanServerConnection();  
			
			//vm内存信息
			MemoryMXBean memory = ManagementFactory.newPlatformMXBeanProxy  
					(mbs,ManagementFactory.MEMORY_MXBEAN_NAME, 
					        MemoryMXBean.class);
			
			
			MemoryInfo heap = new MemoryInfo();
			MemoryInfo nonheap = new MemoryInfo();
			
			MemoryUsage heapMemory = memory.getHeapMemoryUsage();  
			heap.setName("heap堆");
			heap.setInit(heapMemory.getInit()/MB);
			heap.setMax(heapMemory.getMax()/MB);
			heap.setUsed(heapMemory.getUsed()/MB);
			heap.setCommitted(heapMemory.getCommitted()/MB);
			heap.setUtilization(heapMemory.getUsed()*100/heapMemory.getCommitted());
				 
			MemoryUsage nonheapMemory = memory.getNonHeapMemoryUsage();  
			nonheap.setName("non-heap非堆");
			nonheap.setInit(nonheapMemory.getInit()/MB);
			nonheap.setMax(nonheapMemory.getMax()/MB);
			nonheap.setUsed(nonheapMemory.getUsed()/MB);
			nonheap.setCommitted(nonheapMemory.getCommitted()/MB);
			nonheap.setUtilization(nonheapMemory.getUsed()*100/nonheapMemory.getCommitted());

			Map<String,MemoryInfo> res = new HashMap<String,MemoryInfo>();
			res.put("heap", heap);
			res.put("nonheap", nonheap);
	        return res;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;     
    }
	
	// 获取线程信息
	public JVMThreadInfo getThreadInfo(String url) {
		try {
			JMXServiceURL serviceURL = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://118.89.203.197:60001/jmxrmi"); 
			JMXConnector conn = JMXConnectorFactory.connect(serviceURL);  
			MBeanServerConnection mbs=conn.getMBeanServerConnection();  
			
			//线程信息
			ThreadMXBean thread = ManagementFactory.newPlatformMXBeanProxy  
					(mbs,ManagementFactory.THREAD_MXBEAN_NAME, 
							ThreadMXBean.class);
			
			JVMThreadInfo threadInfo = new JVMThreadInfo();
			
			threadInfo.setThreadCount(thread.getThreadCount());
			threadInfo.setPeakThreadCount(thread.getPeakThreadCount());
			threadInfo.setTotalStartedThreadCount(thread.getTotalStartedThreadCount());
			threadInfo.setDaemonThreadCount(thread.getDaemonThreadCount());
			          
	        return threadInfo;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;     
    }  
	
	
	// 获取总线程信息
	public LinkedHashMap<String, Object> getAllInfo(String url) {
		try {
			JMXServiceURL serviceURL = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://localhost:12312/jmxrmi");
//			JMXServiceURL serviceURL = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://118.89.203.197:60001/jmxrmi");
			JMXConnector conn = JMXConnectorFactory.connect(serviceURL);
			MBeanServerConnection mbs=conn.getMBeanServerConnection();  
			
			LinkedHashMap<String, Object> totalInfo = new LinkedHashMap<String, Object>();
			
			//操作系统信息
			OperatingSystemMXBean opMXbean =   
			        ManagementFactory.newPlatformMXBeanProxy(mbs,                 
			        ManagementFactory.OPERATING_SYSTEM_MXBEAN_NAME, OperatingSystemMXBean.class);
			OSInfo osInfo = new OSInfo();
			osInfo.setArch(opMXbean.getArch());
			osInfo.setName(opMXbean.getName());
			osInfo.setVersion(opMXbean.getVersion());
			osInfo.setAvailableProcessors(opMXbean.getAvailableProcessors());
			osInfo.setSystemLoadAverage(opMXbean.getSystemLoadAverage());
			
			
			// 总编译时间
			CompilationMXBean compilation = ManagementFactory.newPlatformMXBeanProxy  
			        (mbs,ManagementFactory.COMPILATION_MXBEAN_NAME, CompilationMXBean.class);
			if(compilation.isCompilationTimeMonitoringSupported()){  
				totalInfo.put("totalCompilationTime", compilation.getTotalCompilationTime());
	        }  
			
			//线程信息
			ThreadMXBean thread = ManagementFactory.newPlatformMXBeanProxy  
					(mbs,ManagementFactory.THREAD_MXBEAN_NAME, 
							ThreadMXBean.class);
			
			JVMThreadInfo threadInfo = new JVMThreadInfo();
			
			threadInfo.setThreadCount(thread.getThreadCount());
			threadInfo.setPeakThreadCount(thread.getPeakThreadCount());
			threadInfo.setTotalStartedThreadCount(thread.getTotalStartedThreadCount());
			threadInfo.setDaemonThreadCount(thread.getDaemonThreadCount());
			
			//加载类信息
			ClassLoadingMXBean classLoad = ManagementFactory.newPlatformMXBeanProxy  
			        (mbs,ManagementFactory.CLASS_LOADING_MXBEAN_NAME, ClassLoadingMXBean.class);
			
			ClassLoadInfo classLoadInfo = new ClassLoadInfo();
			classLoadInfo.setTotalLoadedClassCount(classLoad.getTotalLoadedClassCount());
			classLoadInfo.setLoadedClassCount(classLoad.getLoadedClassCount());
			classLoadInfo.setUnloadedClassCount(classLoad.getUnloadedClassCount());
			
			//vm内存信息
			MemoryMXBean memory = ManagementFactory.newPlatformMXBeanProxy  
					(mbs,ManagementFactory.MEMORY_MXBEAN_NAME, 
					        MemoryMXBean.class);
			
			
			MemoryInfo heap = new MemoryInfo();
			MemoryInfo nonheap = new MemoryInfo();
			
			MemoryUsage heapMemory = memory.getHeapMemoryUsage();  
			heap.setName("heap堆");
			heap.setInit(heapMemory.getInit()/MB);
			heap.setMax(heapMemory.getMax()/MB);
			heap.setUsed(heapMemory.getUsed()/MB);
			heap.setCommitted(heapMemory.getCommitted()/MB);
			heap.setUtilization(heapMemory.getUsed()*100/heapMemory.getCommitted());
				 
			MemoryUsage nonheapMemory = memory.getNonHeapMemoryUsage();  
			nonheap.setName("non-heap非堆");
			nonheap.setInit(nonheapMemory.getInit()/MB);
			nonheap.setMax(nonheapMemory.getMax()/MB);
			nonheap.setUsed(nonheapMemory.getUsed()/MB);
			nonheap.setCommitted(nonheapMemory.getCommitted()/MB);
			nonheap.setUtilization(nonheapMemory.getUsed()*100/nonheapMemory.getCommitted());
			
			//运行信息
			RuntimeMXBean runtime = ManagementFactory.newPlatformMXBeanProxy  
			        (mbs,ManagementFactory.RUNTIME_MXBEAN_NAME, RuntimeMXBean.class);
			RuntimeInfo runtimeInfo = new RuntimeInfo();
			runtimeInfo.setPid(runtime.getName().split("@")[0]);
			runtimeInfo.setSpecName(runtime.getSpecName());
			runtimeInfo.setSpecVendor(runtime.getSpecVendor());
			runtimeInfo.setSpecVersion(runtime.getSpecVersion());
			runtimeInfo.setStartTime(runtime.getStartTime());
			runtimeInfo.setUptime(runtime.getUptime());
			runtimeInfo.setVmName(runtime.getVmName());
			runtimeInfo.setVmVendor(runtime.getVmVendor());
			runtimeInfo.setVmVersion(runtime.getVmVersion());
			runtimeInfo.setInputArguments(runtime.getInputArguments());
			runtimeInfo.setClassPath(runtime.getClassPath());
			runtimeInfo.setBootClassPath(runtime.getBootClassPath());
			runtimeInfo.setLibraryPath(runtime.getLibraryPath());
			
			
			
			totalInfo.put("threadInfo", threadInfo);
			totalInfo.put("heap", heap);
			totalInfo.put("nonheap", nonheap);
			totalInfo.put("classLoadInfo", classLoadInfo);
			totalInfo.put("runtimeInfo", runtimeInfo);

			try {
				ObjectName os = new ObjectName("java.lang:type=OperatingSystem");
				ObjectName codeCache = new ObjectName("java.lang:type=MemoryPool,name=Code Cache");
				ObjectName edenSpace = new ObjectName("java.lang:type=MemoryPool,name=PS Eden Space");
				ObjectName oldGen = new ObjectName("java.lang:type=MemoryPool,name=PS Old Gen");
				ObjectName permGen = new ObjectName("java.lang:type=MemoryPool,name=PS Perm Gen");
				ObjectName survivorSpace = new ObjectName("java.lang:type=MemoryPool,name=PS Survivor Space");
				ObjectName[] memoryObjectName = {codeCache,edenSpace,oldGen ,permGen ,survivorSpace};
				try {
					
					long totalPhysicalMemorySize = (long)mbs.getAttribute(os,"TotalPhysicalMemorySize");
		            long freePhysicalMemorySize = (long) mbs.getAttribute(os,"FreePhysicalMemorySize");
		            long usedPhysicalMemorySize =totalPhysicalMemorySize - freePhysicalMemorySize;  
		            osInfo.setTotalPhysicalMemorySize(totalPhysicalMemorySize/MB);  
		            osInfo.setUsedPhysicalMemorySize(usedPhysicalMemorySize/MB);
		            osInfo.setFreePhysicalMemorySize(freePhysicalMemorySize/MB);
		            
		              
		            long totalSwapSpaceSize = (long)mbs.getAttribute(os,"TotalSwapSpaceSize");  
		            long freeSwapSpaceSize = (long)mbs.getAttribute(os,"FreeSwapSpaceSize");
		            long usedSwapSpaceSize = totalSwapSpaceSize - freeSwapSpaceSize;  
		            osInfo.setTotalSwapSpaceSize(totalSwapSpaceSize/MB);  
		            osInfo.setUsedSwapSpaceSize(usedSwapSpaceSize/MB);
		            osInfo.setFreeSwapSpaceSize(freeSwapSpaceSize/MB);
		            
		            
		            long committedVirtualMemorySize = (long)mbs.getAttribute(os,"CommittedVirtualMemorySize");  
		            osInfo.setCommittedVirtualMemorySize(committedVirtualMemorySize/MB);
		            
		            for (ObjectName objectName : memoryObjectName) {
		            	MemoryInfo memoryInfo = new MemoryInfo();
			            String name = (String) mbs.getAttribute(objectName,"Name"); 
			            CompositeDataSupport usage = (CompositeDataSupport) mbs.getAttribute(objectName,"Usage");  
			            memoryInfo.setName(name);
			            memoryInfo.setInit((Long)usage.get("init")/MB);
			            memoryInfo.setMax((Long)usage.get("max")/MB);
			            memoryInfo.setUsed((Long)usage.get("used")/MB);
			            memoryInfo.setCommitted((Long)usage.get("committed")/MB);
			            memoryInfo.setUtilization((Long)usage.get("used")*100/(Long)usage.get("committed"));
			            totalInfo.put(name.replace(" ", ""), memoryInfo);
					}
		            

		            totalInfo.put("osInfo", osInfo);
		          
				} catch (AttributeNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InstanceNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (MBeanException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (ReflectionException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}  
				
	          
			} catch (MalformedObjectNameException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        
			return totalInfo;    
	        
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
			
		return null;     
    }  
	
}
