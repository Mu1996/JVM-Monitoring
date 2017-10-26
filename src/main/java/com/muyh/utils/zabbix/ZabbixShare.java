package com.muyh.utils.zabbix;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.methods.RequestBuilder;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.*;

public class ZabbixShare {
    private static final Logger logger = LoggerFactory.getLogger(ZabbixShare.class);

    private String auth;


    public String getAuth() {
        return auth;
    }

    public void setAuth(String auth) {
        this.auth = auth;
    }

    public boolean login() throws URISyntaxException {
        String uname ="Admin";
        String upwd ="zabbix" ;

        ZabbixRequest request = ZabbixRequestBuilder.newBuilder().paramEntry("user",uname )
                .paramEntry("password",upwd ).method("user.login").build();
        JSONObject response = call(request);
        String auth = response.getString("result");
        if (auth != null && !auth.isEmpty()) {
            this.setAuth(auth);
            logger.info("login zabbix success!");
            return true;
        }
        logger.info("login zabbix failed!");
        return false;
    }
    /**
     * 查询ITEMS
     * @param hostName  hostIP
     * @param searchKey 查询KEY
     * @param groupName  group名
     * @return item列表
     * @throws Exception 异常
     */
    public JSONObject queryItems(String hostName,String searchKey,String groupName)throws Exception{
        JSONObject response = null;
        JSONObject search = new JSONObject();
        logger.info("queryItems--searchKey: "+searchKey+" hostName:"+hostName+"  groupName: "+groupName);
        search.put("key_", searchKey);
        ZabbixRequest request = ZabbixRequestBuilder.newBuilder().method("item.get")
                .paramEntry("output", "extend")
                .paramEntry("host", hostName)
                .paramEntry("search", search)
                //.paramEntry("group", groupName)
                .build();
        response = call(request);
        return response;
    }
    /**
     * 查询HOST
     * @param hostName  hostIP
     * @return HOST列表
     * @throws Exception 异常
     */
    public JSONObject queryHost(String hostName)throws Exception{
        JSONObject response = null;
        if(login()){
            logger.info("queryHost--hostName: "+hostName);
            JSONObject search = new JSONObject();
            search.put("host", hostName);
            ZabbixRequest request = ZabbixRequestBuilder.newBuilder().method("host.get")
                    .paramEntry("output", "extend")
                    .paramEntry("filter",search)
                    .build();
            response = call(request);
        }
        return response;
    }
    /**
     * 查询Applications
     * @param hostId  hostId
     * @param name 查询名
     * @return Applications列表
     * @throws Exception 异常
     */
    public JSONObject queryApplications(String hostId,String name)throws Exception{
        JSONObject response = null;
        JSONObject search = new JSONObject();
        search.put("key", name);
        logger.info("queryApplications--hostId: "+hostId);
        ZabbixRequest request = ZabbixRequestBuilder.newBuilder().method("application.get")
                .paramEntry("output", "extend")
                .paramEntry("hostids",hostId)
                .paramEntry("filter",search)
                .build();
        response = call(request);
        logger.info(String.format("queryApplications response:%s", response.toJSONString()));
        return response;
    }
    /**
     * hostinterface.get
     * @param hostId hostid
     * @return hostinterface list
     * @throws Exception
     */
    public JSONObject queryHostInterface(String hostId)throws Exception{
        JSONObject response = null;
        logger.info("queryHostInterface--hostId: "+hostId);
        ZabbixRequest request = ZabbixRequestBuilder.newBuilder().method("hostinterface.get")
                .paramEntry("output", "extend")
                .paramEntry("hostids",hostId)
                .build();
        response = call(request);
        logger.info(String.format("queryHostInterface response:%s", response.toJSONString()));
        return response;
    }


    public JSONObject call(ZabbixRequest request) throws URISyntaxException {
        if (request.getAuth() == null) {
            request.setAuth(auth);
        }
        String url ="http://192.168.1.212/zabbix/api_jsonrpc.php";
        try {
            HttpUriRequest httpRequest = RequestBuilder
                    .post().setUri(new URI(url.trim()))
                    .addHeader("Content-Type", "application/json")
                    .setEntity(new StringEntity(JSON.toJSONString(request),"utf-8"))
                    .build();
            CloseableHttpClient httpClient= HttpClients.custom().build();
            CloseableHttpResponse response = httpClient.execute(httpRequest);
            HttpEntity entity = response.getEntity();
            byte[] data = EntityUtils.toByteArray(entity);
            return (JSONObject) JSON.parse(data);
        } catch (IOException e) {
            throw new RuntimeException("DefaultZabbixApi call exception!", e);
        }
    }
    /**
     * 将入参转为需要的格式
     * @param
     * @return
     * @throws Exception
     */
    public static String dateToTimestamp(String time_from) throws Exception {
        Calendar calendar = Calendar.getInstance();
        switch (time_from) {
            case "d":
                calendar.add(Calendar.DAY_OF_YEAR, -1);
                break;
            case "w":
                calendar.add(Calendar.WEEK_OF_YEAR, -1);
                break;
            case "m":
                calendar.add(Calendar.MONTH, -1);
                break;
            case "h":
                calendar.add(Calendar.HOUR,-12);
                break;
            default:
                calendar.set(Calendar.HOUR_OF_DAY, calendar.get(Calendar.HOUR_OF_DAY) - 1);
                break;
        }

        String re_time = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date d;
        d = sdf.parse(sdf.format(calendar.getTime()));
        long l = d.getTime();
        String str = String.valueOf(l);
        re_time = str.substring(0, 10);
        return re_time;
    }
    /**
     * 根据监控项id和主机id查询监控项
     * @param monitorKeys (必须)监控项keys
     * @param hostids 主机ids
     * @param outputs 输出栏位名称
     * @return 符合条件的items json
     * @throws
     */
    public JSONObject queryItemsByKeysHostids(Collection<String> monitorKeys, Collection<String> hostids, String... outputs) {

        try {
            JSONObject filter = new JSONObject();
            filter.put("key_", monitorKeys);
            if (CollectionUtils.isNotEmpty(hostids)) {
                filter.put("hostid", hostids);
            }
            ZabbixRequestBuilder builder = ZabbixRequestBuilder.newBuilder().method("item.get")//
                    .paramEntry("output", ArrayUtils.isEmpty(outputs) ? "extend" : outputs)//
                    .paramEntry("filter", filter)//
                    .paramEntry("selectInterfaces", new String[]{"interfaceid", "hostid", "ip", "type"})
                    .paramEntry("selectTriggers", new String[]{"triggerid", "expression", "state", "status", "value"})
                    .paramEntry("selectHosts", new String[] { "host", "hostid" });//
            ZabbixRequest request = builder.build();
            logger.info(
                    String.format("queryItemsByKeysHostids >>>>request:%s", ToStringBuilder.reflectionToString(request)));
            JSONObject json = call(request);
            logger.info(String.format("queryItemsByKeysHostids <<<response:%s", json.toJSONString()));
            return json;
        } catch (Exception e) {
            logger.error("查询监控信息失败！", e);
        }
        return null;
    }

    /**
     * 根据监控项key查询模板监控项
     * @param monitorKeys
     * @param outputs
     * @return
     * @throws
     */
    public JSONObject queryTemplateItemsByKeys(Collection<String> monitorKeys, String... outputs) {

        try {
            JSONObject filter = new JSONObject();
            filter.put("key_", monitorKeys);
            ZabbixRequestBuilder builder = ZabbixRequestBuilder.newBuilder().method("item.get")//
                    .paramEntry("output", ArrayUtils.isEmpty(outputs) ? "extend" : outputs)//
                    .paramEntry("filter", filter)//
                    .paramEntry("templated", true);//
            ZabbixRequest request = builder.build();
            logger.info(
                    String.format("queryTemplateItemsByKeys >>>>request:%s", ToStringBuilder.reflectionToString(request)));
            JSONObject json = call(request);
            logger.info(String.format("queryTemplateItemsByKeys <<<response:%s", json.toJSONString()));
            return json;
        } catch (Exception e) {
            logger.error("查询监控信息失败！", e);
        }
        return null;
    }
    /**
     * 根据主机名称查询主机
     * @param hostNames 主机名称
     * @param outputs 输出栏位名称
     * @return 符合条件的主机
     * @throws
     */
    public JSONObject queryHostsByHostnames(Collection<String> hostNames, String ...outputs)  {
        try {
            JSONObject jsonHostInterfaces = queryInterfacesByHostnames(hostNames, "hostid");

            JSONArray hostArray = jsonHostInterfaces.getJSONArray("result");
            Set<String> hostids = new HashSet<String>();
            for(int i = 0; i< hostArray.size(); i++){
                hostids.add(hostArray.getJSONObject(i).getString("hostid"));
            }
            if(CollectionUtils.isEmpty(hostids)){
                logger.error("主机不存在，HostNames : " + hostNames);
            }
            JSONObject filter = new JSONObject();
            filter.put("hostid", hostids);
            ZabbixRequest request = ZabbixRequestBuilder.newBuilder().method("host.get")//
                    .paramEntry("filter", filter)//
                    .paramEntry("selectInterfaces", new String[]{"interfaceid", "ip", "type", "hostid"})//
                    .paramEntry("output", ArrayUtils.isEmpty(outputs) ? "extend" : outputs)//
                    .build();
            logger.info(String.format("queryHostsByHostnames >>>>request:%s", ToStringBuilder.reflectionToString(request)));
            JSONObject json = call(request);

            logger.info(String.format("queryHostsByHostnames <<<response:%s", json.toJSONString()));
            return json;
        } catch (Exception e) {
            logger.error("host不存在：" + e.getMessage(), e);
        }
        return null;
    }
    /**
     * 通过name，查询模板详情
     * @param name
     * @return
     * @throws URISyntaxException
     */
    public JSONObject queryTemplateByName(String name) throws URISyntaxException{
        JSONObject response = null;
        if(login()){
            List<String> out = Arrays.asList(name);
            List<String> output = Arrays.asList("itemid","name","key_");
            Map<String,Object> filter = new HashMap<String, Object>();
            filter.put("host", out);
            ZabbixRequest request = ZabbixRequestBuilder.newBuilder().method("template.get")
                    .paramEntry("output", "extend")
                    .paramEntry("selectItems", output)
                    .paramEntry("filter", filter)
                    .build();
            response = call(request);
        }
        return response;
    }
    /**
     * 通过itemid，查询模板详情
     * @param
     * @return
     * @throws URISyntaxException
     */
    public JSONObject queryTemplateByItemids(List<String> itemids, Collection<String> hostids, String...outputs) throws URISyntaxException {
        JSONObject response = null;
        ZabbixRequest request = ZabbixRequestBuilder.newBuilder().method("template.get")
                .paramEntry("itemids", itemids)
                .paramEntry("hostids", hostids)
                .paramEntry("selectHosts", new String[]{"hostid", "host"})
                .paramEntry("output", ArrayUtils.isEmpty(outputs) ? "extend" : outputs)
                .build();
        logger.info(String.format("queryTemplateByItemids >>>>request:%s", ToStringBuilder.reflectionToString(request)));
        response = call(request);
        logger.info(String.format("queryTemplateByItemids <<<response:%s", response.toJSONString()));
        return response;
    }

    private JSONObject queryInterfacesByHostnames(Collection<String> hostNames, String... outputs) {
        try {
            JSONObject filter = new JSONObject();
            filter.put("ip", hostNames);
            ZabbixRequest request = ZabbixRequestBuilder.newBuilder().method("hostinterface.get")//
                    .paramEntry("filter", filter)//
                    .paramEntry("output", ArrayUtils.isEmpty(outputs) ? "extend" : outputs)//
                    .build();
            logger.info(String.format("queryInterfacesByHostnames >>>>request:%s", ToStringBuilder.reflectionToString(request)));
            JSONObject json = call(request);

            logger.info(String.format("queryInterfacesByHostnames <<<response:%s", json.toJSONString()));
            return json;
        } catch (Exception e) {
            logger.error("host ip不存在：" + e.getMessage(), e);
        }
        return null;
    }
}
