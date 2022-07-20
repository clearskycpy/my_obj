package com.cpy.workbench.service.impl;

import com.cpy.commons.contants.Contants;
import com.cpy.commons.utils.DateUtils;
import com.cpy.commons.utils.UUIDUtils;
import com.cpy.settings.domain.User;
import com.cpy.workbench.domain.Activity;
import com.cpy.workbench.domain.Clue;
import com.cpy.workbench.domain.Customer;
import com.cpy.workbench.mapper.ClueMapper;
import com.cpy.workbench.mapper.CustomerMapper;
import com.cpy.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionForPage(map);
    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int editClueById(Clue clue) {
        return clueMapper.updateClueById(clue);
    }

    @Override
    public Clue queryClueForDetailById(String clueId) {
        return clueMapper.selectClueForDetailById(clueId);
    }

    @Override
    public void saveClueConvert(Map<String, Object> map) {
//        获取到当前用户
        User user = (User) map.get(Contants.SESSION_USER);
        Clue clue = clueMapper.selectByPrimaryKey((String) map.get("clueId"));
//        将线索里面的数据封装到customer
        Customer customer = new Customer();

        customer.setId(UUIDUtils.createUUID());
        customer.setOwner(user.getId());
        customer.setCreateBy(user.getId());
        customer.setAddress(clue.getAddress());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setName(clue.getFullname());
        customer.setDescription(clue.getDescription());
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());

//        保存客户
        customerMapper.insertCustomer(customer);

//        封装联系人






    }

}
