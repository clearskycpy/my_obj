package com.cpy.workbench.web.controller;

import com.cpy.settings.domain.User;
import com.cpy.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        // 调用了service层的方法查询所有用户
        List<User> userList = userService.queryAllUsers();
        // 存数据
        request.setAttribute("userList",userList);
        return "/workbench/activity/index";
    }

}
