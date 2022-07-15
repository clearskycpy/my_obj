package com.cpy.settings.service.impl;

import com.cpy.settings.domain.DicValue;
import com.cpy.settings.mapper.DicValueMapper;
import com.cpy.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("dicValueService")
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
