package com.cpy.settings.web.controller;

import com.cpy.commons.domain.ReturnObject;
import com.cpy.settings.domain.User;
import com.cpy.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private UserService userService;
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
    @RequestMapping("/settings/qx/user/login.do")
    public  @ResponseBody Object login(String loginAct, String loginPwd, String idRemPwd
    ,HttpServletRequest request){
//        封装参数
        Map<String ,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
//        map.put("isRemPwd",isRemPwd);  不需要
        User user = userService.queryUserByLoginActPwd(map);
        ReturnObject returnObject = new ReturnObject();
        if (user == null){
            returnObject.setCode("0");
            returnObject.setMessage("用户名或者密码错误");
//            登录失败
        }else {
//            进一步判断 账号是否合法
//            判断是否过期了  将这个时间转换成为一个时间戳 .  或者比较两个字符串
            System.out.println("__________________执行了判断___________________________");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String nowTime = sdf.format(new Date());
            if (nowTime.compareTo(user.getEditTime())>0){
//                过期了 登录失败
                System.out.println("过期了+++++++++++++++++++++++++++++++++++++++++++++++++");
                returnObject.setCode("0");
                returnObject.setMessage("用户已经过期");
            }else if ("0".equals(user.getLockState())){
//                登录失败
                System.out.println("zhanghao suoding++++++++++++++++++++++++++++++++++++++++++");
                returnObject.setCode("0");
                returnObject.setMessage("账号已经被锁定");
            }else if (!user.getAllowIps().contains(request.getRemoteAddr())){
//                ip不在里面
                System.out.println("ipbuzia++++++++++++++++++++++++++++++++++++");
                returnObject.setCode("0");
                returnObject.setMessage("ip受限不能登录");
            }else {
//                登录成功
                System.out.println("*********************************true");
                returnObject.setCode("1");
                returnObject.setMessage("登录成功");
            }
        }
        System.out.println("执行了");
        return returnObject;

    }

}
