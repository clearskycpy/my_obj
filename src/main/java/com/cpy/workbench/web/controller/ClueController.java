package com.cpy.workbench.web.controller;

import com.cpy.commons.contants.Contants;
import com.cpy.commons.domain.ReturnObject;
import com.cpy.commons.utils.DateUtils;
import com.cpy.commons.utils.UUIDUtils;
import com.cpy.settings.domain.DicValue;
import com.cpy.settings.domain.User;
import com.cpy.settings.service.DicValueService;
import com.cpy.settings.service.UserService;
import com.cpy.workbench.domain.Activity;
import com.cpy.workbench.domain.Clue;
import com.cpy.workbench.domain.ClueRemark;
import com.cpy.workbench.service.ActivityService;
import com.cpy.workbench.service.ClueRemarkService;
import com.cpy.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    /**实现页面跳转, 同时将数据字典值传过去，以及所有的用户
     * @return
     */
    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
//        获取所有的用户
        List<User> userList = userService.queryAllUsers();
//        获取字典值
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
//        将数据保存在作用域
//        保存称呼
        request.setAttribute("appellationList",appellationList);
//        保存线索状态
        request.setAttribute("clueStateList",clueStateList);
//        保存线索来源
        request.setAttribute("sourceList",sourceList);
//        保存用户
        request.setAttribute("userList",userList);
//      页面转跳
        return "workbench/clue/index";
    }

    /**
     * 保存创建的线索
     * @return
     */
    @RequestMapping("/workbench/clue/saveCreateClue.do")
    public @ResponseBody Object saveCreateClue(Clue clue, HttpSession session){
//        封装参数
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        clue.setCreateBy(user.getId());
        clue.setId(UUIDUtils.createUUID());

//        定义返回值
        ReturnObject returnObject = new ReturnObject();
//        调用service层方法
        try {
            int success = clueService.saveCreateClue(clue);
            if (success > 0){
//                保存成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("创建失败，请联系管理员");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("创建失败，请联系管理员");

        }
        return returnObject;
    }

//    实现分页查询线索记录
    @RequestMapping("/workbench/clue/queryClueConditionForPage.do")
    public @ResponseBody Object queryClueConditionForPage(String fullname, String company,String phone,String owner,
                                                          String mphone,String state,String source,int pageNo,int pageSize){
        Map<String,Object> map = new HashMap();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("source",source);
        map.put("beginNO",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
//        调用service层方法
        List<Clue> clueList = clueService.queryClueByConditionForPage(map);
//        System.out.println("+++++++++++++++++++++++++++++++++++"+clueList.size()+"++++++++++++++++++++++");
//
        int totalRows = clueService.queryCountOfClueByCondition(map);

//        System.out.println("______________________________"+totalRows+"______________________________________");
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("clueList",clueList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    public @ResponseBody Object deleteClueByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
//        调用service层
        try {
            int success = clueService.deleteClueByIds(id);
            if (success>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("成功删除了"+success+"条数据");
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("删除失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("删除失败");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueById.do")
    public @ResponseBody Object selectClueById(String id){
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    @RequestMapping("/workbench/clue/saveEditClueById.do")
    public @ResponseBody Object saveEditClueById(Clue clue, HttpSession session){
//        封装参数
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));
//        调用service层方法
        ReturnObject returnObject = new ReturnObject();
        try {
            int success = clueService.editClueById(clue);
            if (success > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setCode("系统繁忙。请稍后重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setCode("系统繁忙。请稍后重试");
        }
        return returnObject;
    }

    /**
     * 点击线索名称的链接，实现页面转跳
     * @return
     */
    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(String id, HttpServletRequest request){
//        查询线索的详细信息，还有线索的备注
        Clue clue = clueService.queryClueForDetailById(id);
//        System.out.println("===================================="+clue.toString());
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkForDetailByClueId(id);
//        System.out.println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"+clueRemarkList.size());
//        保存线索的备注和线索的信息
        List<Activity> activityList = activityService.queryActivityForDetailByClueId(id);
        request.setAttribute("clue",clue);
        request.setAttribute("clueRemarkList",clueRemarkList);
        request.setAttribute("activityList",activityList);
        return "/workbench/clue/detail";
    }


    @RequestMapping("/workbench/clue/queryActivityByNameAndClueId.do")
    public @ResponseBody Object queryActivityByNameAndClueId(String activityName,String id){
        Map<String, String> map = new HashMap<>();
//        封装参数
        map.put("activityName",activityName);
        map.put("clueId",id);
        List<Activity> activityList = activityService.queryActivityForDetailByNameAndClueId(map);
        return activityList;
    }

    /**
     * 转跳到线索转换页面
     * @param clueId
     * @return
     */
    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String clueId,HttpServletRequest request){
        Clue clue = clueService.queryClueForDetailById(clueId);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("clue",clue);
        request.setAttribute("stageList",stageList);
        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/queryActivityByNameAndClueIdExcuse.do")
    public @ResponseBody Object queryActivityByNameAndClueIdExcuse(String activityName,String id){
        Map<String, String> map = new HashMap<>();
//        封装参数
        map.put("activityName",activityName);
        map.put("clueId",id);
        List<Activity> activityList = activityService.queryActivityByNameAndClueIdExcuse(map);
        return activityList;
    }

    @RequestMapping("/workbench/clue/convertClue.do")
    public @ResponseBody Object convertClue(String clueId, String money, String expectedDate,
                                            String stage, String activityId, String isCreateTran,HttpSession session){
        Map<String, Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("money",money);
        map.put("expectedDate",expectedDate);
        map.put("stage",stage);
        map.put("activityId",activityId);
        map.put("isCreateTran",isCreateTran);
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        map.put(Contants.SESSION_USER,user);

        ReturnObject returnObject = new ReturnObject();
        try {
            clueService.saveClueConvert(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙,请稍后重试");

        }
        return returnObject;



    }


}
