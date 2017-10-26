package com.muyh.utils.zabbix;

import java.util.concurrent.atomic.AtomicInteger;

public class ZabbixRequestBuilder {

    private static final AtomicInteger nextId = new AtomicInteger(1);

    ZabbixRequest request ;

    ZabbixRequestObject obj= new ZabbixRequestObject();
    ZabbixRequestParams param = new ZabbixRequestParams();

    private  ZabbixRequestBuilder(String str){
        if("obj".equals(str)){
            this.request= obj;
        }else{
            this.request = param;
        }
    }



    static public ZabbixRequestBuilder newBuilder(String str){
        return new ZabbixRequestBuilder(str);
    }

    static public ZabbixRequestBuilder newBuilder(){
        return new ZabbixRequestBuilder("param");
    }

    public ZabbixRequest build(){
        if(request.getId() == null){
            request.setId(nextId.getAndIncrement());
        }
        return request;
    }

    public ZabbixRequestBuilder version(String version){
        request.setJsonrpc(version);
        return this;
    }

    public ZabbixRequestBuilder paramEntry(String key, Object value){
        if(request instanceof ZabbixRequestParams){
            ((ZabbixRequestParams) request).putParam(key, value);
        }
        return this;
    }

    /**
     * Do not necessary to call this method.If don not set id, ZabbixApi will auto set request auth..
     * @param auth
     * @return
     */
    public ZabbixRequestBuilder auth(String auth){
        request.setAuth(auth);
        return this;
    }

    public ZabbixRequestBuilder method(String method){
        request.setMethod(method);
        return this;
    }

    /**
     * Do not necessary to call this method.If don not set id, RequestBuilder will auto generate.
     * @param id
     * @return
     */
    public ZabbixRequestBuilder id(Integer id){
        request.setId(id);
        return this;
    }


    public ZabbixRequestBuilder object(Object obj){
        if(request instanceof ZabbixRequestObject){
            ((ZabbixRequestObject)request).setParams(obj);
        }

        return this;

    }
}