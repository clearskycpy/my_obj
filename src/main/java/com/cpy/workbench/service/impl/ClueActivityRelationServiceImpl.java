package com.cpy.workbench.service.impl;

import com.cpy.workbench.domain.ClueActivityRelation;
import com.cpy.workbench.mapper.ClueActivityRelationMapper;
import com.cpy.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public int saveCreateActivityRelationServices(List<ClueActivityRelation> clueActivityRelations) {
        return clueActivityRelationMapper.insertClueActivityRelations(clueActivityRelations);
    }

    @Override
    public int deleteClueActivityRelationByClueIdAndClueId(Map<String, String> map) {
        return clueActivityRelationMapper.deleteClueActivityRelationByClueIdAndClueId(map);
    }

}
