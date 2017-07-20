package com.muyh.controller;/*
 * Created by muyonghui on 2017/6/11.
 */

import com.muyh.model.UserAccount;
import com.muyh.service.UserService;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/user")
@CrossOrigin(origins = "http://localhost:4200")
public class UserCtrl {
    @Autowired
    UserService userService;

    @ResponseBody
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public Map<String,Object> addUser(@RequestBody JSONObject jsonObject) {
        UserAccount user = new UserAccount();
        user.setMobile(jsonObject.getString("mobile"));
        user.setPassword(jsonObject.getString("password"));
//        System.out.println(jsonObject);
        UserAccount result = userService.getUser(user);
        Map<String ,Object> userRes = new HashMap<String, Object>();
        userRes.put("user",result);
        Map<String,Object> res = new HashMap<String, Object>();
        res.put("code","0");
        res.put("returnValue",userRes);
        res.put("errorReason","");

        return res;
    }
}
