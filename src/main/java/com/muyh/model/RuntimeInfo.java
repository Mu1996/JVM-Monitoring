package com.muyh.model;

import java.util.List;

public class RuntimeInfo {

	private String pid;   				//进程PID
	private String specName;			//jvm规范名称
	private String specVendor;			//jvm规范运营商
	private String specVersion;			//jvm规范版本
	private long startTime;				//jvm启动时间（毫秒）
	private long uptime;				//jvm正常运行时间（毫秒）
	private String vmName;				//jvm名称
	private String vmVendor;			//jvm运营商
	private String vmVersion;			//jvm实现版本
	private List<String> inputArguments;//vm参数
	private String classPath;			//类路径
	private String bootClassPath;		//引导类路径
	private String libraryPath;			//库路径
	
	public String getPid() {
		return pid;
	}
	public void setPid(String pid) {
		this.pid = pid;
	}
	public String getSpecName() {
		return specName;
	}
	public void setSpecName(String specName) {
		this.specName = specName;
	}
	public String getSpecVendor() {
		return specVendor;
	}
	public void setSpecVendor(String specVendor) {
		this.specVendor = specVendor;
	}
	public String getSpecVersion() {
		return specVersion;
	}
	public void setSpecVersion(String specVersion) {
		this.specVersion = specVersion;
	}
	public long getStartTime() {
		return startTime;
	}
	public void setStartTime(long startTime) {
		this.startTime = startTime;
	}
	public long getUptime() {
		return uptime;
	}
	public void setUptime(long uptime) {
		this.uptime = uptime;
	}
	public String getVmName() {
		return vmName;
	}
	public void setVmName(String vmName) {
		this.vmName = vmName;
	}
	public String getVmVendor() {
		return vmVendor;
	}
	public void setVmVendor(String vmVendor) {
		this.vmVendor = vmVendor;
	}
	public String getVmVersion() {
		return vmVersion;
	}
	public void setVmVersion(String vmVersion) {
		this.vmVersion = vmVersion;
	}
	public List<String> getInputArguments() {
		return inputArguments;
	}
	public void setInputArguments(List<String> inputArguments) {
		this.inputArguments = inputArguments;
	}
	public String getClassPath() {
		return classPath;
	}
	public void setClassPath(String classPath) {
		this.classPath = classPath;
	}
	public String getBootClassPath() {
		return bootClassPath;
	}
	public void setBootClassPath(String bootClassPath) {
		this.bootClassPath = bootClassPath;
	}
	public String getLibraryPath() {
		return libraryPath;
	}
	public void setLibraryPath(String libraryPath) {
		this.libraryPath = libraryPath;
	}
}
