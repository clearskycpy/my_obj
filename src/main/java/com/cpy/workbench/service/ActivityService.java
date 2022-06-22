package com.cpy.workbench.service;

import com.cpy.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    /**
     * 保存创建的市场活动
     * @param activity  活动实体类
     * @return 返回插入的市场活动的条数
     */
    int saveCreateActivity(Activity activity);

    /**
     * 分页查询市场活动信息
     * @param map
     * @return
     */
    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询市场活动的总记录条数
     */
    int queryCountOfActivityByCondition(Map<String,Object> map);

    /**
     * deleteActivityByIds
     * 根据id删除市场活动
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 根据id查询活动
     * @param id
     * @return
     */
    Activity selectById(String id);

    /**
     * 根据id修改市场活动
     * @param activity
     * @return
     */
    int updateActivity(Activity activity);

    /**
     * 查询所有的市场活动
     * @return
     */
    List<Activity> queryAllActivities();

    /**
     * 根据选中的id 查询市场活动
     * @param ids
     * @return
     */
    List<Activity> queryActivityByIds(String[] ids);

    /**
     * 导入市场活动
     * @param activities
     * @return
     */
    int saveActivityByExcel(List<Activity> activities);


    /**
     * 查询市场活动的详细信息
     * @param id
     * @return
     */
    Activity queryActivityForDetailById(String id);

}
