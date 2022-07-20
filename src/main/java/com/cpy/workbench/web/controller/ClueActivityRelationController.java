package com.cpy.workbench.web.controller;

import com.cpy.commons.contants.Contants;
import com.cpy.commons.domain.ReturnObject;
import com.cpy.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class ClueActivityRelationController {

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/deleteClueActivityRelation.do")
    public @ResponseBody Object deleteClueActivityRelation(String clueId, String activityId){
//        封装参数
        Map<String, String> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("activityId",activityId);
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = clueActivityRelationService.deleteClueActivityRelationByClueIdAndClueId(map);
            if (i > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试");
        }
        return returnObject;
    }

}
