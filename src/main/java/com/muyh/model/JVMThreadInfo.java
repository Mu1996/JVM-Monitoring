package com.muyh.model;

public class JVMThreadInfo {
	private int threadCount;				//仍活动的线程总数
	private int peakThreadCount;			//峰值
	private long totalStartedThreadCount;	//线程总数（被创建并执行过的线程总数）
	private int daemonThreadCount;			//当时仍活动的守护线程（daemonThread）总数
	public int getThreadCount() {
		return threadCount;
	}
	public void setThreadCount(int threadCount) {
		this.threadCount = threadCount;
	}
	public int getPeakThreadCount() {
		return peakThreadCount;
	}
	public void setPeakThreadCount(int peakThreadCount) {
		this.peakThreadCount = peakThreadCount;
	}
	public long getTotalStartedThreadCount() {
		return totalStartedThreadCount;
	}
	public void setTotalStartedThreadCount(long totalStartedThreadCount) {
		this.totalStartedThreadCount = totalStartedThreadCount;
	}
	public int getDaemonThreadCount() {
		return daemonThreadCount;
	}
	public void setDaemonThreadCount(int daemonThreadCount) {
		this.daemonThreadCount = daemonThreadCount;
	}

}
