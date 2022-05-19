package com.cpy.settings.service;

import com.cpy.settings.domain.User;

import java.util.Map;

public interface UserService {
    User queryUserByLoginActPwd(Map<String , Object> map);
}
