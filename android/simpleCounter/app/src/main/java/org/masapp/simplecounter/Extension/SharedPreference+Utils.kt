package org.masapp.simplecounter.Extension

import android.app.Activity
import android.content.Context
import org.json.JSONArray

/**
 * Created by masapp on 2018/04/24.
 */

class SharedPreference(var activity: Activity) {

  // リストの保存
  fun saveArrayList(key: String, arrayList: ArrayList<String>) {
    val shardPreferences = activity.getSharedPreferences("saveData", Context.MODE_PRIVATE)
    val shardPrefEditor = shardPreferences.edit()
    val jsonArray = JSONArray(arrayList)
    shardPrefEditor.putString(key, jsonArray.toString())
    shardPrefEditor.apply()
  }

  // リストの読み込み
  fun loadArrayList(key: String): ArrayList<String> {
    val shardPreferences = activity.getSharedPreferences("saveData", Context.MODE_PRIVATE)
    val jsonArray = JSONArray(shardPreferences.getString(key, "[]"))
    var array: ArrayList<String> = arrayListOf()
    for (i in 0 until jsonArray.length()) {
      array.add(jsonArray.get(i).toString())
    }
    return array
  }
}