package com.yiie.entity.data;

import java.io.Serializable;
import java.util.Map;

/**
 * MyData resultMap = new DataMap();
 * @author liuye
 *
 */
public interface IData<K,V> extends Map<String,Object>, Serializable {

    public abstract Object get(String s, Object obj);

    public abstract String[] getNames();

    public abstract String getString(String s);

    public abstract String getString(String s, String s1);

    public abstract int getInt(String s);

    public abstract int getInt(String s, int i);

    public abstract double getDouble(String s);

    public abstract double getDouble(String s, double d);

    public abstract boolean getBoolean(String s);

    public abstract boolean getBoolean(String s, boolean flag);
    
    public abstract Long getLong(String s);
    
    public abstract Long getLong(String s,Long l);
}
