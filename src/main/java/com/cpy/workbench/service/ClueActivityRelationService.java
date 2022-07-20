package com.cpy.workbench.service;

import com.cpy.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationService {
//    保存线索关联市场活动
    int saveCreateActivityRelationServices(List<ClueActivityRelation> clueActivityRelations);

    int deleteClueActivityRelationByClueIdAndClueId(Map<String, String> map);

}
