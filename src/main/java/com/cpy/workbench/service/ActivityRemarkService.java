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

    int insertActivityRemark(ActivityRemark activityRemark);
}
