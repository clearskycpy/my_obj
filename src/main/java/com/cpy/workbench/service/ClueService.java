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
}
