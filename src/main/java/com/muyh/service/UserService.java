package com.muyh.service;/*
 * Created by muyonghui on 2017/5/30.
 */

import com.muyh.dao.UserAccountDao;
import com.muyh.model.UserAccount;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    UserAccountDao dao;

    public UserAccount getUser(UserAccount userAccount) {
        return dao.getUser(userAccount);
    }

    public void addUser(UserAccount userAccount) {
        dao.addUser(userAccount);
    }

}
