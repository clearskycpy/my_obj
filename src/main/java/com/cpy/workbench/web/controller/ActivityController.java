package com.cpy.workbench.web.controller;

import com.cpy.commons.contants.Contants;
import com.cpy.commons.domain.ReturnObject;
import com.cpy.commons.utils.DateUtils;
import com.cpy.commons.utils.HSSFWorkbookUtils;
import com.cpy.commons.utils.IOUtils;
import com.cpy.commons.utils.UUIDUtils;
import com.cpy.settings.domain.User;
import com.cpy.settings.service.UserService;
import com.cpy.workbench.domain.Activity;
import com.cpy.workbench.domain.ActivityRemark;
import com.cpy.workbench.service.ActivityRemarkService;
import com.cpy.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;
    /**
     * 实现查询所有的用户
     * @param request
     * @return
     */
    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        // 调用了service层的方法查询所有用户
        List<User> userList = userService.queryAllUsers();
        // 存数据
        userList.forEach(user -> System.out.println(user));
        request.setAttribute("userList",userList);
        return "/workbench/activity/index";
    }

    /**
     * 实现创建用户
     * @param activity
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody Object saveCreateActivity(Activity activity, HttpSession session){  // @ResponseBody 添加这个字符串可以自动生成json字符串
//        装填参数
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setId(UUIDUtils.createUUID());
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        activity.setCreateBy(user.getId());

        ReturnObject returnObject = new ReturnObject();
        try {
            int i = activityService.saveCreateActivity(activity);
            if (i >0 ) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("添加失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("添加失败");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public @ResponseBody Object queryActivityByConditionForPage(String name,String owner, String startDate,String endDate,
    int pageNo,int pageSize){
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNO",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByCondition(map);
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("activityList",activityList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    /**
     * 根据id 删除
     * 参数id要和页面发送过来的数据保持一致
     * @return
     */
    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    public @ResponseBody Object deleteActivityByIds(String[] id){
        ReturnObject re = new ReturnObject();
        try {
            int i = activityService.deleteActivityByIds(id);
            if (i == id.length){
//                说明删除成功了
                re.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                re.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            }
        }catch (Exception e){
            e.printStackTrace();
            re.setMessage("系统繁忙，请稍后重试....");
        }
        return re;
    }

    /**
     * 根据市场id查询市场活动
     * @param id
     * @return
     */
    @RequestMapping("/workbench/activity/queryActivityById.do")
    public @ResponseBody Object queryActivityById(String id){
        Activity activity = activityService.selectById(id);
        return activity;
    }

    /**
     * 通过前台发送过来的Activity对象 更新Activity
     * @param activity
     * @return
     */
    @RequestMapping("/workbench/activity/updateActivityById.do")
    public @ResponseBody Object updateActivityById(Activity activity, HttpSession session){
        System.out.println("controller being");
        ReturnObject retObj = new ReturnObject();
//        装填参数修改时间
        // 将修改人信息和修改时间 添加到activity中
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtils.formatDateTime(new Date()));

        try{
            int success = activityService.updateActivity(activity);
            if (success == 1){
                retObj.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                retObj.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                retObj.setMessage("系统繁忙，请稍后重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            retObj.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            retObj.setMessage("系统繁忙，请稍后重试");
        }
        return retObj;
    }

    /**
     * 测试文件下载功能
     * @param response
     * @throws IOException
     */
    @RequestMapping("/workbench/activity/activityFileDownload.do")
    public void activityFileDownload(HttpServletResponse response) throws IOException {

//        设置响应类型 。 （因为不使用springmvc的框架返回数据,需要自己处理数据）
        response.setContentType("application/octet-stream;charset=UTF-8");
        OutputStream outputStream = response.getOutputStream();
//        接收到响应信息都是直接打开这些字节，（或者使用其他应用程序打开 除非实在打不开才会下载）
        String filename = "attachment;filename="+UUIDUtils.createUUID().substring(0,8)+".xls";
        response.addHeader("content-Disposition",filename); // 设置了默认是下载。文件名后面定义"attachment;filename=name.xls"
//        读取磁盘上的文件。然后写到response里面
        FileInputStream fileInputStream = new FileInputStream("");
//       流之间的读取
        byte[] buffer = new byte[1024*4];
        int len = 0;
        while ((len = fileInputStream.read(buffer)) != -1){
            outputStream.write(buffer,0,len);
        }
        fileInputStream.close();
        outputStream.flush(); // 这个流不能关，因为是tomcat创建的

    }
    @RequestMapping("/workbench/activity/exportAllActivities.do")
    public void exportAllActivities(HttpServletResponse response) throws IOException {
//        拿到所有的市场活动
        List<Activity> activities = activityService.queryAllActivities();
//        定义一个工作区
        HSSFWorkbook wbJob = HSSFWorkbookUtils.CreateHSSFWorkbook(activities);
        response.setContentType("application/octet-stream;charset=UTF-8");
        OutputStream outputStream = response.getOutputStream();
        String filename = "attachment;filename="+UUIDUtils.createUUID().substring(0,8)+".xls";
        response.addHeader("content-Disposition",filename);
        wbJob.write(outputStream);   // 直接往输出流写数据 ， 也不会临时生成文件
        wbJob.close();
        outputStream.flush(); // 这个流不能关，因为是tomcat创建的

    }
    @RequestMapping("/workbench/activity/exportActivitiesByIds.do")
    public void exportActivitiesByIds(HttpServletResponse response ,String[] id) throws IOException {

//        查询出所有的市场活动，根据选中的
        List<Activity> activities = activityService.queryActivityByIds(id);
//        调用HSSFWorkbook工具函数将内容转换为文件
        HSSFWorkbook activityJob = HSSFWorkbookUtils.CreateHSSFWorkbook(activities);

//        设置浏览器接收到的文件格式，和获取输出流
        response.setContentType("application/octet-stream;charset=UTF-8");
        OutputStream outputStream = response.getOutputStream();
        String filename = "attachment;filename="+UUIDUtils.createUUID().substring(0,8)+".xls";
        response.addHeader("content-Disposition",filename);

        activityJob.write(outputStream);

//        关闭工作区对象和刷新输出流
        activityJob.close();
        outputStream.flush();

    }

    @RequestMapping("/workbench/activity/activityFileUpload.do")
    public @ResponseBody Object activityFileUpload(MultipartFile activityFile,String fileName,HttpSession session) throws IOException {

        User user = (User) session.getAttribute(Contants.SESSION_USER);

        InputStream inputStream = activityFile.getInputStream(); // 将这个文件转化为一个流
        ReturnObject returnObject = new ReturnObject();
        try {
            List<Activity> activityList = HSSFWorkbookUtils.getActivityList(inputStream,user.getId());
            for(Activity activity : activityList){
                System.out.println(activity);
            }
            //        调用业务层
            int updateNum = activityService.saveActivityByExcel(activityList);

            if (updateNum == 0 ){
//            说明上传失败了
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("数据格式错误，上传失败(请注意数据上传格式)");
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("成功导入"+updateNum+"条数据");

            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("数据格式错误，上传失败(请注意数据上传格式)");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String id,HttpServletRequest request){
//        根据市场活动的id查出来市场活动的详细信息
        Activity activity = activityService.queryActivityForDetailById(id);
//        根据市场活动的id查出所有的备注来
        List<ActivityRemark> activityRemarks = activityRemarkService.queryActivityRemarkForDetailById(id);

        request.setAttribute("activity",activity);
        request.setAttribute("activityRemarks",activityRemarks);

//        转跳页面
        return "/workbench/activity/detail";
    }
}
