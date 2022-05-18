package com.cpy.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {
//    http://localhost:8080/crm/  mvc省略了前面的一串
    @RequestMapping("/")
    public String index(){
//        请求转发
        return "index";
        // 使用了视图解析器  mvc.xml文件 配置了
    }

}
