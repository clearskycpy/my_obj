package com.cpy.settings.web.controller;

import com.cpy.commons.contants.Contants;
import com.cpy.commons.domain.ReturnObject;
import com.cpy.commons.utils.DateUtils;
import com.cpy.settings.domain.User;
import com.cpy.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private UserService userService;
    /**
     * 主页面跳转
     * 这个url要和这个controller方法 处理完请求之后返回的资源目录保持一致
     * 入 /WEB-INF/pages/settings/qx/user/toLogin.do
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
//        http://localhost:8080/crm/WEB-INF/pages/settings/qx/user/login.jsp
        return "settings/qx/user/login";
    }

    /**
     *  登录功能  十天免密登录
     * @param loginAct  从前台获取到的 账号
     * @param loginPwd  从前台获取到的 密码
     * @param idRemPwd  是否记住密码
     * @param request   请求域
     * @param session   会话域
     * @param response
     * @return
     */
    @RequestMapping("/settings/qx/user/login.do")
    public  @ResponseBody Object login(String loginAct, String loginPwd, String idRemPwd
    , HttpServletRequest request, HttpSession session, HttpServletResponse response){
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
//            下面这一段逻辑有问题_____________________________
            String nowTime = DateUtils.formatDateTime(new Date());
            if (nowTime.compareTo(user.getExpireTime())>0){
//                过期了 登录失败
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("用户已经过期");
            }else if (Contants.RETURN_OBJECT_CODE_FAIL.equals(user.getLockState())){
//                登录失败
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已经被锁定");
            }else if (!user.getAllowIps().contains(request.getRemoteAddr())){
//                ip不在里面
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("ip受限不能登录");
            }else {
//                登录成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                // 将用户存储起来 使用 session域
                session.setAttribute(Contants.SESSION_USER,user);
//                如果  记住密码的话 往外添加 cookie
                if ("true".equals(idRemPwd)){
                    Cookie c1 = new Cookie("loginAct",user.getLoginAct());
                    c1.setMaxAge(10*24*60*60);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd",user.getLoginPwd());
                    c2.setMaxAge(10*24*60*60);
                    response.addCookie(c2);
                }else {
                    Cookie c1 = new Cookie("loginAct","1");
                    c1.setMaxAge(0);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd","1");
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                }
            }
        }
        return returnObject;

    }

    /**
     * 实现安全退出环境
     * @param response 响应
     * @param session 会话域
     * @return
     */
    @RequestMapping("/settings/qx/user/logOut.do")
    public String logOut(HttpServletResponse response, HttpSession session){
        Cookie c1 = new Cookie("loginAct","1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd","1");
        c2.setMaxAge(0);
        response.addCookie(c2);
//        销毁session
        session.invalidate();
        return "redirect:/";
    }

}
