package com.cpy.settings.service.impl;

import com.cpy.settings.domain.User;
import com.cpy.settings.mapper.UserMapper;
import com.cpy.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;
@Service("userService")
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public User queryUserByLoginActPwd(Map<String, Object> map) {

        return userMapper.selectUserByLoginActAndPwd(map);
    }
}
