package org.masapp.simplecounter.Adapter

import android.app.Activity
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.Button
import android.widget.RelativeLayout
import android.widget.TextView
import com.google.gson.Gson
import org.masapp.simplecounter.Constant.ColorSettings
import org.masapp.simplecounter.Item
import org.masapp.simplecounter.R

/**
 * Created by masapp on 2018/04/25.
 */
class ContentAdapter(var activity: Activity, var items: ArrayList<Item>, var key: String) : BaseAdapter() {
  val inflater: LayoutInflater
  val relativeLayout: RelativeLayout

  init {
    inflater = activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
    relativeLayout = activity.findViewById(R.id.contentLayout) as RelativeLayout
  }

  override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
    var v = convertView
    var holder: ContentViewHolder? = null

    v?.let {
      holder = it.tag as ContentViewHolder?
    } ?: run {
      v = inflater.inflate(R.layout.listview_content, null)
      holder = ContentViewHolder(
          v?.findViewById(R.id.color) as View,
          v?.findViewById(R.id.title) as TextView,
          v?.findViewById(R.id.count) as TextView,
          v?.findViewById(R.id.minus) as Button,
          v?.findViewById(R.id.plus) as Button
      )

      v?.tag = holder
    }

    holder?.let {
      var index = position
      val gson = Gson()
      val countView = it.countView
      while (index > ColorSettings.colorArray.size) {
        index -= ColorSettings.colorArray.size
      }
      countView.text = items[position].count
      it.colorView.setBackgroundColor(ColorSettings.colorArray[index])
      it.titleView.text = items[position].title
      it.minusButton.setOnClickListener {
        var count = items[position].count.toInt()
        if (count > 0) {
          count -= 1
          items[position].count = count.toString()
          activity.getSharedPreferences("saveData", Context.MODE_PRIVATE).edit().putString(key, gson.toJson(items)).apply()
          countView.text = count.toString()
          relativeLayout.invalidate()
        }
      }
      it.plusButton.setOnClickListener {
        var count = items[position].count.toInt()
        if (count < 9999) {
          count += 1
          items[position].count = count.toString()
          activity.getSharedPreferences("saveData", Context.MODE_PRIVATE).edit().putString(key, gson.toJson(items)).apply()
          countView.text = count.toString()
          relativeLayout.invalidate()
        }
      }
    }

    return v as View
  }

  override fun getItem(position: Int): Any {
    return items[position]
  }

  override fun getItemId(position: Int): Long {
    return position.toLong()
  }

  override fun getCount(): Int {
    return items.size
  }

  class ContentViewHolder(var colorView: View, var titleView: TextView, var countView: TextView, var minusButton: Button, var plusButton: Button)
}
