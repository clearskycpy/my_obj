package com.cpy.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexAction {
    @RequestMapping("/index1")
    public String index1(){
        System.out.println("ndfjkadhfkdjsafh");
        System.out.println("begin");
        http://localhost:8080/crm/WEB-INF/pages/settings/qx/user/login.html
        return "forward:/WEB-INF/pages/settings/qx/user/login.html";
    }

}
