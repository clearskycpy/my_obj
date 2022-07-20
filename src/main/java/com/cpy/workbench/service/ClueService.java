package com.cpy.workbench.service;

import com.cpy.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    /**
     * save clue
     * @param clue
     * @return
     */
    int saveCreateClue(Clue clue);

    /**
     * 分页查询市场活动信息
     * @param map
     * @return
     */
    List<Clue> queryClueByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询市场活动的总记录条数
     */
    int queryCountOfClueByCondition(Map<String,Object> map);

    /**
     * 根据线索id删除线索
     * @param ids
     * @return
     */
    int deleteClueByIds(String[] ids);

    Clue queryClueById(String id);

    int editClueById(Clue clue);

    Clue queryClueForDetailById(String clueId);

    /**
     * 实现线索转换
     * @param map
     */
    void saveClueConvert(Map<String,Object> map);
}
