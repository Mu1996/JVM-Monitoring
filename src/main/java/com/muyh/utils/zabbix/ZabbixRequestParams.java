package com.muyh.utils.zabbix;

import java.util.HashMap;
import java.util.Map;

public class ZabbixRequestParams extends ZabbixRequest{

    private Map<String, Object> params = new HashMap<String, Object>();

    public Map<String, Object> getParams() {
        return params;
    }

    public void setParams(Map<String, Object> params) {
        this.params = params;
    }


    public void putParam(String key, Object value) {
        params.put(key, value);
    }

    public Object removeParam(String key) {
        return params.remove(key);
    }
}
