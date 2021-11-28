package com.yiie.entity.data;

import com.yiie.entity.data.IData;

import java.util.List;

/**
 * MyDataList list = new DataArrayList();
 * @author liuye
 *
 */
public interface IDataList<K,V>  extends List<IData<K,V>> {
    public abstract int count();
    public abstract Object get(int index, String name);
    
}
