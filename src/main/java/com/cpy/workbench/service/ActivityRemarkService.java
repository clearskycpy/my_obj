package com.cpy.workbench.service;

import com.cpy.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    /**
     * 根据市场活动id查询备注信息
     * @param activityId
     * @return
     */
    List<ActivityRemark> queryActivityRemarkForDetailById(String activityId);

    /**
     * 添加市场活动备注
     * @param activityRemark
     * @return
     */
    int saveActivityRemark(ActivityRemark activityRemark);

    /**
     * 根据id删除市场活动备注
     * @param activityRemarkId
     * @return
     */
    int deleteActivityRemarkById(String activityRemarkId);

    int saveEditActivityRemark(ActivityRemark activityRemark);
}
