package com.cpy.workbench.web.controller;

import com.cpy.commons.contants.Contants;
import com.cpy.commons.domain.ReturnObject;
import com.cpy.commons.utils.DateUtils;
import com.cpy.commons.utils.UUIDUtils;
import com.cpy.settings.domain.User;
import com.cpy.workbench.domain.ActivityRemark;
import com.cpy.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveActivityRemark.do")
    public @ResponseBody Object saveActivityRemark(ActivityRemark remark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
//        封装参数
        remark.setId(UUIDUtils.createUUID());
        remark.setCreateTime(DateUtils.formatDateTime(new Date()));
        remark.setCreateBy(user.getId());
        remark.setEditFlag(Contants.EDIT_FLAG_FALSE);
//        执行service层方法
        ReturnObject ret = new ReturnObject();
        try{
            int i = activityRemarkService.saveActivityRemark(remark);
            if (i <= 0){
                ret.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                ret.setMessage("添加备注失败");
            }else {
                ret.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                ret.setRetData(remark);
            }
        }catch(Exception e){
            e.printStackTrace();
            ret.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            ret.setMessage("添加备注失败");
        }

        return ret;
    }

    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    public @ResponseBody Object deleteActivityRemarkById(String id){
        ReturnObject ret = new ReturnObject();
        try {
//            调用service层实现
            int i = activityRemarkService.deleteActivityRemarkById(id);
            if (i > 0){
                ret.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                ret.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                ret.setMessage("删除失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            ret.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            ret.setMessage("删除失败");
        }
        return ret;
    }

    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    public @ResponseBody Object saveEditActivityRemark(ActivityRemark activityRemark,HttpSession session){
        ReturnObject ret = new ReturnObject();
//        封装参数
        activityRemark.setEditFlag(Contants.EDIT_FLAG_TRUE);
        activityRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        User user = (User) session.getAttribute(Contants.SESSION_USER);

        activityRemark.setEditBy(user.getId());
        try{
            //        调用service层方法
            int success = activityRemarkService.saveEditActivityRemark(activityRemark);
            if (success > 0){
//            更新成功
                ret.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                ret.setRetData(activityRemark);
            }else {
                ret.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                ret.setMessage("更新失败，请稍后重试");
            }
        }catch (Exception e){
            ret.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            ret.setMessage("更新失败，请稍后重试");
            e.printStackTrace();

        }
        return ret;
    }
}
