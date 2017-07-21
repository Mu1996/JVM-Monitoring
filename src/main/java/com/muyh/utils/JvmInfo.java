package com.muyh.utils;

import java.io.IOException;
import java.lang.management.ClassLoadingMXBean;  
import java.lang.management.CompilationMXBean;  
import java.lang.management.GarbageCollectorMXBean;  
import java.lang.management.ManagementFactory;  
import java.lang.management.MemoryMXBean;  
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;  
import java.lang.management.OperatingSystemMXBean;  
import java.lang.management.RuntimeMXBean;  
import java.lang.management.ThreadInfo;  
import java.lang.management.ThreadMXBean;  
import java.lang.reflect.InvocationTargetException;  
import java.lang.reflect.Method;  
import java.util.Arrays;  
import java.util.List;

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

public class JvmInfo{  
  
    static final long MB = 1024 * 1024;  
    private JMXServiceURL serviceURL;
    private JMXConnector conn;
    private MBeanServerConnection mbs;
    private MemoryMXBean memBean;
    private OperatingSystemMXBean opMXbean;

    JvmInfo(){
    	try {
            serviceURL = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://118.89.203.197:39906/jmxrmi");
            conn = JMXConnectorFactory.connect(serviceURL);
            mbs=conn.getMBeanServerConnection();  
            //获取远程memorymxbean  
            memBean=ManagementFactory.newPlatformMXBeanProxy  
            (mbs,ManagementFactory.MEMORY_MXBEAN_NAME, MemoryMXBean.class);  
            //获取远程opretingsystemmxbean  
            
        } catch (Exception e) {  
            e.printStackTrace();  
        }   
    	
    }
    
    public static void main(String[] args) {  
          
    	JvmInfo jvm = new JvmInfo();  
    	
        //打印系统信息  
        System.out.println("===========打印系统信息==========");  
        jvm.printOperatingSystemInfo();  
        //打印编译信息  
        System.out.println("===========打印编译信息==========");  
        jvm.printCompilationInfo();  
        //打印类加载信息  
        System.out.println("===========打印类加载信息==========");  
        jvm.printClassLoadingInfo();  
        //打印运行时信息  
        System.out.println("===========打印运行时信息==========");  
        jvm.printRuntimeInfo();  
        //打印内存管理器信息  
        System.out.println("===========打印内存管理器信息==========");  
        jvm.printMemoryManagerInfo();  
        //打印垃圾回收信息  
        System.out.println("===========打印垃圾回收信息==========");  
//        jvm.printGarbageCollectorInfo();  
        //打印vm内存  
//        System.out.println("===========打印vm内存信息==========");  
        jvm.printMemoryInfo();  
        //打印vm各内存区信息  
//        System.out.println("===========打印vm各内存区信息==========");  
        jvm.printMemoryPoolInfo();  
        //打印线程信息  
        System.out.println("===========打印线程==========");  
        jvm.printThreadInfo();  
          
    }  
      
      
    private void printOperatingSystemInfo(){  
    	try {
			opMXbean =   
			        ManagementFactory.newPlatformMXBeanProxy(mbs,                 
			        ManagementFactory.OPERATING_SYSTEM_MXBEAN_NAME, OperatingSystemMXBean.class);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}          //相当于System.getProperty("os.name").  
        System.out.println("系统名称:"+opMXbean.getName());  
        //相当于System.getProperty("os.version").  
        System.out.println("系统版本:"+opMXbean.getVersion());  
        //相当于System.getProperty("os.arch").  
        System.out.println("操作系统的架构:"+opMXbean.getArch());  
        //相当于 Runtime.availableProcessors()  
        System.out.println("可用的内核数:"+opMXbean.getAvailableProcessors());  
        System.out.println("系统平均负载:"+opMXbean.getSystemLoadAverage());  
        ObjectName objectName;
		try {
			objectName = new ObjectName("java.lang:type=OperatingSystem");
	        try {
	        	 System.out.println(mbs.getAttribute(objectName,"FreePhysicalMemorySize"));
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
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} catch (MalformedObjectNameException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        if(isSunOsMBean(opMXbean)){  
            long totalPhysicalMemory = getLongFromOperatingSystem(opMXbean,"getTotalPhysicalMemorySize");  
            long freePhysicalMemory = getLongFromOperatingSystem(opMXbean, "getFreePhysicalMemorySize");  
            long usedPhysicalMemorySize =totalPhysicalMemory - freePhysicalMemory;  
              
            System.out.println("总物理内存(M):"+totalPhysicalMemory/MB);  
            System.out.println("已用物理内存(M):"+usedPhysicalMemorySize/MB);  
            System.out.println("剩余物理内存(M):"+freePhysicalMemory/MB);  
              
            long  totalSwapSpaceSize = getLongFromOperatingSystem(opMXbean, "getTotalSwapSpaceSize");  
            long freeSwapSpaceSize = getLongFromOperatingSystem(opMXbean, "getFreeSwapSpaceSize");  
            long usedSwapSpaceSize = totalSwapSpaceSize - freeSwapSpaceSize;  
              
            System.out.println("总交换空间(M):"+totalSwapSpaceSize/MB);  
            System.out.println("已用交换空间(M):"+usedSwapSpaceSize/MB);  
            System.out.println("剩余交换空间(M):"+freeSwapSpaceSize/MB);  
        }  
    }  
      
    private static long getLongFromOperatingSystem(OperatingSystemMXBean operatingSystem, String methodName) {  
        try {  
            final Method method = operatingSystem.getClass().getMethod(methodName,  
                    (Class<?>[]) null);  
            method.setAccessible(true);  
            return (Long) method.invoke(operatingSystem, (Object[]) null);  
        } catch (final InvocationTargetException e) {  
            if (e.getCause() instanceof Error) {  
                throw (Error) e.getCause();  
            } else if (e.getCause() instanceof RuntimeException) {  
                throw (RuntimeException) e.getCause();  
            }  
            throw new IllegalStateException(e.getCause());  
        } catch (final NoSuchMethodException e) {  
            throw new IllegalArgumentException(e);  
        } catch (final IllegalAccessException e) {  
            throw new IllegalStateException(e);  
        }  
    }  
  
    private void printCompilationInfo(){  
        CompilationMXBean compilation;
		try {
			compilation = ManagementFactory.newPlatformMXBeanProxy  
			        (mbs,ManagementFactory.COMPILATION_MXBEAN_NAME, CompilationMXBean.class);
			if(compilation.isCompilationTimeMonitoringSupported()){  
	            System.out.println("总编译时间："+compilation.getTotalCompilationTime()+"秒");
	        }  
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
    }  
      
    private void printClassLoadingInfo(){  
        ClassLoadingMXBean classLoad;
		try {
			classLoad = ManagementFactory.newPlatformMXBeanProxy  
			        (mbs,ManagementFactory.CLASS_LOADING_MXBEAN_NAME, ClassLoadingMXBean.class);
			System.out.println("已加载类总数："+classLoad.getTotalLoadedClassCount());  
	        System.out.println("已加载当前类："+classLoad.getLoadedClassCount());  
	        System.out.println("已卸载类总数："+classLoad.getUnloadedClassCount());  
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
        
          
    }  
      
    private void printRuntimeInfo(){  
        RuntimeMXBean runtime;
		try {
			runtime = ManagementFactory.newPlatformMXBeanProxy  
			        (mbs,ManagementFactory.RUNTIME_MXBEAN_NAME, RuntimeMXBean.class);
			
			System.out.println("进程PID="+runtime.getName().split("@")[0]);  
	        System.out.println("jvm规范名称:"+runtime.getSpecName());  
	        System.out.println("jvm规范运营商:"+runtime.getSpecVendor());  
	        System.out.println("jvm规范版本:"+runtime.getSpecVersion());  
	        //返回虚拟机在毫秒内的开始时间。该方法返回了虚拟机启动时的近似时间  
	        System.out.println("jvm启动时间（毫秒）:"+runtime.getStartTime());  
	        //相当于System.getProperties  
	        System.out.println("获取System.properties:"+runtime.getSystemProperties());  
	        System.out.println("jvm正常运行时间（毫秒）:"+runtime.getUptime());  
	        //相当于System.getProperty("java.vm.name").  
	        System.out.println("jvm名称:"+runtime.getVmName());  
	        //相当于System.getProperty("java.vm.vendor").  
	        System.out.println("jvm运营商:"+runtime.getVmVendor());  
	        //相当于System.getProperty("java.vm.version").  
	        System.out.println("jvm实现版本:"+runtime.getVmVersion());  
	        List<String> args = runtime.getInputArguments();  
	        if(args != null && !args.isEmpty()){  
	            System.out.println("vm参数:");  
	            for(String arg : args){  
	                System.out.println(arg);  
	            }  
	        }  
	        System.out.println("类路径:"+runtime.getClassPath());  
	        System.out.println("引导类路径:"+runtime.getBootClassPath());  
	        System.out.println("库路径:"+runtime.getLibraryPath());  
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
    }  
      
    private void printMemoryManagerInfo() {  
    	
    	ObjectName objectName;
		try {
			objectName = new ObjectName("java.lang:type=MemoryPool,name=Code Cache");
			try {
				String[] managerNames = (String[]) mbs.getAttribute(objectName, "MemoryManagerNames");
				
				CompositeDataSupport usage =  (CompositeDataSupport) mbs.getAttribute(objectName, "Usage");

				System.out.println(managerNames[0]);
				System.out.println(usage.get("init"));
				
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
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} catch (MalformedObjectNameException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

    }  
      
    private void printGarbageCollectorInfo(){  
        List<GarbageCollectorMXBean> garbages;
		try {
			garbages = (List<GarbageCollectorMXBean>) ManagementFactory.newPlatformMXBeanProxy  
					(mbs,ManagementFactory.GARBAGE_COLLECTOR_MXBEAN_DOMAIN_TYPE, GarbageCollectorMXBean.class);
			 for(GarbageCollectorMXBean garbage : garbages){  
		            System.out.println("垃圾收集器：名称="+garbage.getName()+",收集="+garbage.getCollectionCount()+",总花费时间="  
		        +garbage.getCollectionTime()+",内存区名称="+Arrays.deepToString(garbage.getMemoryPoolNames()));  
		        }  
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       
    }  
      
    private void printMemoryInfo(){  
        MemoryMXBean memory;
		try {
			memory = ManagementFactory.newPlatformMXBeanProxy  
					(mbs,ManagementFactory.MEMORY_MXBEAN_NAME, 
					        MemoryMXBean.class);
			
			MemoryUsage headMemory = memory.getHeapMemoryUsage();  
	        System.out.println("head堆:");  
	        System.out.println("\t初始(M):"+headMemory.getInit()/MB);  
	        System.out.println("\t最大(上限)(M):"+headMemory.getMax()/MB);  
	        System.out.println("\t当前(已使用)(M):"+headMemory.getUsed()/MB);  
	        System.out.println("\t提交的内存(已申请)(M):"+headMemory.getCommitted()/MB);  
	        System.out.println("\t使用率:"+headMemory.getUsed()*100/headMemory.getCommitted()+"%");  
	          
	        System.out.println("non-head非堆:");  
	        MemoryUsage nonheadMemory = memory.getNonHeapMemoryUsage();  
	        System.out.println("\t初始(M):"+nonheadMemory.getInit()/MB);  
	        System.out.println("\t最大(上限)(M):"+nonheadMemory.getMax()/MB);  
	        System.out.println("\t当前(已使用)(M):"+nonheadMemory.getUsed()/MB);  
	        System.out.println("\t提交的内存(已申请)(M):"+nonheadMemory.getCommitted()/MB);  
	        System.out.println("\t使用率:"+nonheadMemory.getUsed()*100/nonheadMemory.getCommitted()+"%"); 
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
         
    }  
      
    private static void printMemoryPoolInfo(){  
        List<MemoryPoolMXBean> pools = ManagementFactory.getMemoryPoolMXBeans();  
        if(pools != null && !pools.isEmpty()){  
            for(MemoryPoolMXBean pool : pools){  
                //只打印一些各个内存区都有的属性，一些区的特殊属性，可看文档或百度  
                //最大值，初始值，如果没有定义的话，返回-1，所以真正使用时，要注意  
                System.out.println("vm内存区:\n\t名称="+pool.getName()+"\n\t所属内存管理者="+Arrays.deepToString(pool.getMemoryManagerNames())  
                        +"\n\t ObjectName="+pool.getObjectName()+"\n\t初始大小(M)="+pool.getUsage().getInit()/MB  
                        +"\n\t最大(上限)(M)="+pool.getUsage().getMax()/MB  
                        +"\n\t已用大小(M)="+pool.getUsage().getUsed()/MB  
                        +"\n\t已提交(已申请)(M)="+pool.getUsage().getCommitted()/MB  
                        +"\n\t使用率="+(pool.getUsage().getUsed()*100/pool.getUsage().getCommitted())+"%");  
              
            }  
        }  
    }  
      
    private void printThreadInfo(){  
        ThreadMXBean thread;
		try {
			thread = ManagementFactory.newPlatformMXBeanProxy  
					(mbs,ManagementFactory.THREAD_MXBEAN_NAME, 
							ThreadMXBean.class);
			System.out.println("ObjectName="+thread.getObjectName());  
	        System.out.println("仍活动的线程总数="+thread.getThreadCount());  
	        System.out.println("峰值="+thread.getPeakThreadCount());  
	        System.out.println("线程总数（被创建并执行过的线程总数）="+thread.getTotalStartedThreadCount());  
	        System.out.println("当初仍活动的守护线程（daemonThread）总数="+thread.getDaemonThreadCount());  
	          
	        //检查是否有死锁的线程存在  
	        long[] deadlockedIds =  thread.findDeadlockedThreads();  
	        if(deadlockedIds != null && deadlockedIds.length > 0){  
	            ThreadInfo[] deadlockInfos = thread.getThreadInfo(deadlockedIds);  
	            System.out.println("死锁线程信息:");  
	            System.out.println("\t\t线程名称\t\t状态\t\t");  
	            for(ThreadInfo deadlockInfo : deadlockInfos){  
	                System.out.println("\t\t"+deadlockInfo.getThreadName()+"\t\t"+deadlockInfo.getThreadState()  
	                        +"\t\t"+deadlockInfo.getBlockedTime()+"\t\t"+deadlockInfo.getWaitedTime()  
	                        +"\t\t"+deadlockInfo.getStackTrace().toString());  
	            }  
	        }  
	        long[] threadIds = thread.getAllThreadIds();  
	        if(threadIds != null && threadIds.length > 0){  
	            ThreadInfo[] threadInfos = thread.getThreadInfo(threadIds);  
	            System.out.println("所有线程信息:");  
	            System.out.println("\t\t线程名称\t\t\t\t\t状态\t\t\t\t\t线程id");  
	            for(ThreadInfo threadInfo : threadInfos){  
	                System.out.println("\t\t"+threadInfo.getThreadName()+"\t\t\t\t\t"+threadInfo.getThreadState()  
	                        +"\t\t\t\t\t"+threadInfo.getThreadId());  
	            }  
	        }  
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
          
    }  
      
    private static boolean isSunOsMBean(OperatingSystemMXBean operatingSystem) {  
        final String className = operatingSystem.getClass().getName();
        return "sun.management.OperatingSystemImpl".equals(className)  
                || "sun.management.UnixOperatingSystem".equals(className);  
    }  
}  