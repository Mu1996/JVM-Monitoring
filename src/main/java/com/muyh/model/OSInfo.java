package com.muyh.model;

public class OSInfo {

	private String name;                	//系统名称
	private String version;					//系统版本			
	private String arch;					//操作系统的架构
	private int availableProcessors;		//可用的内核数
	private double systemLoadAverage;		//系统平均负载
	private long totalPhysicalMemorySize;	//总物理内存(M)
	private long usedPhysicalMemorySize;	//已用物理内存(M)
	private long freePhysicalMemorySize;	//剩余物理内存(M)
	private long totalSwapSpaceSize;		//总交换空间(M)
	private long usedSwapSpaceSize;			//已用交换空间(M)
	private long freeSwapSpaceSize;			//剩余交换空间(M)
	private long committedVirtualMemorySize;//提交的虚拟内存

	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getArch() {
		return arch;
	}
	public void setArch(String arch) {
		this.arch = arch;
	}
	public int getAvailableProcessors() {
		return availableProcessors;
	}
	public void setAvailableProcessors(int availableProcessors) {
		this.availableProcessors = availableProcessors;
	}
	public double getSystemLoadAverage() {
		return systemLoadAverage;
	}
	public void setSystemLoadAverage(double systemLoadAverage) {
		this.systemLoadAverage = systemLoadAverage;
	}
	public long getTotalPhysicalMemorySize() {
		return totalPhysicalMemorySize;
	}
	public void setTotalPhysicalMemorySize(long totalPhysicalMemorySize) {
		this.totalPhysicalMemorySize = totalPhysicalMemorySize;
	}
	public long getUsedPhysicalMemorySize() {
		return usedPhysicalMemorySize;
	}
	public void setUsedPhysicalMemorySize(long usedPhysicalMemorySize) {
		this.usedPhysicalMemorySize = usedPhysicalMemorySize;
	}
	public long getFreePhysicalMemorySize() {
		return freePhysicalMemorySize;
	}
	public void setFreePhysicalMemorySize(long freePhysicalMemorySize) {
		this.freePhysicalMemorySize = freePhysicalMemorySize;
	}
	public long getTotalSwapSpaceSize() {
		return totalSwapSpaceSize;
	}
	public void setTotalSwapSpaceSize(long totalSwapSpaceSize) {
		this.totalSwapSpaceSize = totalSwapSpaceSize;
	}
	public long getUsedSwapSpaceSize() {
		return usedSwapSpaceSize;
	}
	public void setUsedSwapSpaceSize(long usedSwapSpaceSize) {
		this.usedSwapSpaceSize = usedSwapSpaceSize;
	}
	public long getFreeSwapSpaceSize() {
		return freeSwapSpaceSize;
	}
	public void setFreeSwapSpaceSize(long freeSwapSpaceSize) {
		this.freeSwapSpaceSize = freeSwapSpaceSize;
	}
	public long getCommittedVirtualMemorySize() {
		return committedVirtualMemorySize;
	}
	public void setCommittedVirtualMemorySize(long committedVirtualMemorySize) {
		this.committedVirtualMemorySize = committedVirtualMemorySize;
	}

}
