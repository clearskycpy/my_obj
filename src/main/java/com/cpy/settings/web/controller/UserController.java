package com.cpy.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UserController {
    /**
     * 这个url要和这个controller方法 处理完请求之后返回的资源目录保持一致
     * 入 /WEB-INF/pages/settings/qx/user/toLogin.do
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        System.out.println("Test begin");
//        http://localhost:8080/crm/WEB-INF/pages/settings/qx/user/login.jsp
        return "settings/qx/user/login";
    }

}
