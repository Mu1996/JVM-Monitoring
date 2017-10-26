package com.muyh.utils.zabbix;

import java.net.URISyntaxException;

public class ZabbixDemo {

    public static void main(String[] args) {
        ZabbixShare zabbixShare = new ZabbixShare();
        try {
//            zabbixShare.login();
            System.out.println(zabbixShare.queryHost("agent25"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
