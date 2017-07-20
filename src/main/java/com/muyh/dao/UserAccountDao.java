package com.muyh.dao;
/*
 * Created by muyonghui on 2017/5/30.
 */

import com.muyh.model.UserAccount;
import org.springframework.stereotype.Repository;

@Repository
public interface UserAccountDao {

    public UserAccount getUser(UserAccount userAccount);
    public void addUser(UserAccount userAccount);
    public void updateUser(UserAccount userAccount);
    public void deleteUser(int UserId);
}
