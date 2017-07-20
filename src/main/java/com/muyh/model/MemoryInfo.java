package com.muyh.model;

public class MemoryInfo {
	private String name;			//名称 heap堆 or non-heap堆
	private long init;				//初始(M)
	private long max;				//最大(上限)(M)
	private long used;				//当前(已使用)(M)
	private long committed;			//提交的内存(已申请)(M)
	private double utilization;		//使用率 
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public long getInit() {
		return init;
	}
	public void setInit(long init) {
		this.init = init;
	}
	public long getMax() {
		return max;
	}
	public void setMax(long max) {
		this.max = max;
	}
	public long getUsed() {
		return used;
	}
	public void setUsed(long used) {
		this.used = used;
	}
	public long getCommitted() {
		return committed;
	}
	public void setCommitted(long committed) {
		this.committed = committed;
	}
	public double getUtilization() {
		return utilization;
	}
	public void setUtilization(double utilization) {
		this.utilization = utilization;
	}
}
