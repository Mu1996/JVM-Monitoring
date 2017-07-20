package com.muyh.model;

public class ClassLoadInfo {

	private long totalLoadedClassCount;  //已加载类总数
	private long loadedClassCount;		//已加载当前类
	private long unloadedClassCount;		//已卸载类总数
	
	public long getTotalLoadedClassCount() {
		return totalLoadedClassCount;
	}
	public void setTotalLoadedClassCount(long totalLoadedClassCount) {
		this.totalLoadedClassCount = totalLoadedClassCount;
	}
	public long getLoadedClassCount() {
		return loadedClassCount;
	}
	public void setLoadedClassCount(long loadedClassCount) {
		this.loadedClassCount = loadedClassCount;
	}
	public long getUnloadedClassCount() {
		return unloadedClassCount;
	}
	public void setUnloadedClassCount(long unloadedClassCount) {
		this.unloadedClassCount = unloadedClassCount;
	}
	
	
}
