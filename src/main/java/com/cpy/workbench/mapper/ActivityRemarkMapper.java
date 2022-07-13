package com.cpy.workbench.mapper;

import com.cpy.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Mon Jul 11 17:18:49 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Mon Jul 11 17:18:49 CST 2022
     */
    int insert(ActivityRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Mon Jul 11 17:18:49 CST 2022
     */
    int insertSelective(ActivityRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Mon Jul 11 17:18:49 CST 2022
     */
    ActivityRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Mon Jul 11 17:18:49 CST 2022
     */
    int updateByPrimaryKeySelective(ActivityRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Mon Jul 11 17:18:49 CST 2022
     */
    int updateByPrimaryKey(ActivityRemark record);

    List<ActivityRemark> selectActivityRemarkForDetailByActivityId(String activityId);

    /**
     * 添加市场活动备注
     * @param activityRemark
     * @return
     */

    int insertActivityRemark(ActivityRemark activityRemark);

    /**
     * 删除市场活动备注
     * @param activityRemarkId
     * @return
     */
    int deleteActivityRemark(String activityRemarkId);

    int updateRemarkActivity(ActivityRemark activityRemark);
}