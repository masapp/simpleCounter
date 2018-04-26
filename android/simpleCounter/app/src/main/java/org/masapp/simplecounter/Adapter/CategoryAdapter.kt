package org.masapp.simplecounter.Adapter

import android.app.Activity
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView
import org.masapp.simplecounter.Constant.ColorSettings
import org.masapp.simplecounter.R

/**
 * Created by masapp on 2018/04/24.
 */
class CategoryAdapter(var activity: Activity, var items: ArrayList<String>) : BaseAdapter() {
  val inflater: LayoutInflater

  init {
    inflater = activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
  }

  override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
    var v = convertView
    var holder: CategoryViewHolder? = null

    v?.let {
      holder = it.tag as CategoryViewHolder?
    } ?: run {
      v = inflater.inflate(R.layout.listview_category, null)
      holder = CategoryViewHolder(
          v?.findViewById(R.id.color) as View,
          v?.findViewById(R.id.title) as TextView
      )

      v?.tag = holder
    }

    holder?.let {
      var index = position
      while (index > ColorSettings.colorArray.size) {
        index -= ColorSettings.colorArray.size
      }
      it.colorView.setBackgroundColor(ColorSettings.colorArray[index])
      it.titleView.text = items[position]
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

  class CategoryViewHolder(var colorView: View, var titleView: TextView)
}
