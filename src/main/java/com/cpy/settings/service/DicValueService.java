package com.cpy.settings.service;

import com.cpy.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
