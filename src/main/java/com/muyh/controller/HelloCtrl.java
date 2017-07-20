package com.muyh.controller;

//import com.alibaba.fastjson.JSONObject;

import com.muyh.model.UserAccount;
import com.muyh.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by muyonghui on 2017/5/29.
 */

@Controller
@RequestMapping(value = "/")
public class HelloCtrl {

    @Autowired
    UserService userService;


    @RequestMapping(value = "/hello", method = RequestMethod.GET)
    public String printHello(ModelMap model) {
        model.addAttribute("msg", "Spring MVC Hello World");
        model.addAttribute("name", "muyonghui");
        return "hello";
    }

    @RequestMapping(value = "/getUser", method = RequestMethod.GET)
    public String getUser(ModelMap model) {
        UserAccount user = new UserAccount();
        user.setPassword("123456");
        user.setMobile("myh");
        UserAccount result = userService.getUser(user);
        model.addAttribute("msg", result.getId());
        model.addAttribute("name", result.getMobile());
        return "hello";
    }

    //match automatically
    @ResponseBody
    @RequestMapping(value = "/findUser", method = RequestMethod.GET)
    public Map<String,Object> addUser(ModelMap model, String mobile, String password) {
        UserAccount user = new UserAccount();
        user.setPassword(password);
        user.setMobile(mobile);
        UserAccount result = userService.getUser(user);
        Map<String,Object> res = new HashMap<String, Object>();
        res.put("code","0");
        res.put("returnValue",result);
        res.put("errorReason","");

        return res;
    }

    //redirect
    @RequestMapping("/redirect")
    public String redirect(){
        return "redirect:hello";
    }
    
    @ResponseBody
    @RequestMapping(value = "/getJvmInfo", method = RequestMethod.GET)
    public String showJvmInfo(ModelMap model) {
        return "123";
    }


}
