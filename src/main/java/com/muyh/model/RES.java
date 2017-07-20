package com.muyh.model;

public class RES{
	
	public int code;
	public Object returnValue;
	public String errorReason;
	public RES(){
		
	}
	public RES(int code, Object returnValue, String errorReason){
		this.setCode(code);
		this.returnValue = returnValue;
		this.setErrorReason(errorReason);
	}
	
	public Object getReturnValue() {
		return returnValue;
	}
	
	public void setReturnValue(String returnValue) {
		this.returnValue = returnValue;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getErrorReason() {
		return errorReason;
	}

	public void setErrorReason(String errorReason) {
		this.errorReason = errorReason;
	}
	 
	 
}
