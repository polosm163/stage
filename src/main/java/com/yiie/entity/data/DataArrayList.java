package com.yiie.entity.data;
 
import com.yiie.entity.data.IData;

import java.util.ArrayList;
/**
 * IDataList list = new DataArrayList();
 * @author liuye
 * 
 */
public class DataArrayList<K,V> extends ArrayList<IData<K,V>> implements IDataList<K,V> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public int count() {
		return size();
	}
	
    public Object get(int index, String name)
    {
        IData<K,V> data = (IData<K,V>)get(index);
        return data != null ? data.get(name) : null;
    }

}
