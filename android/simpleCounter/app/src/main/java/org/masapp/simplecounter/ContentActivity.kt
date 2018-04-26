package org.masapp.simplecounter

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.graphics.Color
import android.graphics.Point
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.Toolbar
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.EditText
import android.widget.ListView
import android.widget.RelativeLayout
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.MobileAds
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import org.masapp.simplecounter.Adapter.ContentAdapter
import org.masapp.simplecounter.Constant.AdSettings
import org.masapp.simplecounter.Extension.dp

/**
 * Created by masapp on 2018/04/25.
 */
class ContentActivity : AppCompatActivity() {

  lateinit var items: ArrayList<Item>
  lateinit var adapter: ContentAdapter
  lateinit var category: String
  private val gson = Gson()

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_content)

    val displaySize = getDisplaySize(this)
    val relativeLayout = findViewById(R.id.contentLayout) as RelativeLayout
    category = intent.getStringExtra("TITLE")

    // background
    val background = View(this)
    background.setBackgroundColor(Color.WHITE)
    background.layoutParams = RelativeLayout.LayoutParams(displaySize.x, displaySize.y)
    relativeLayout.addView(background)

    // toolbar
    val toolBar = Toolbar(this)
    toolBar.title = category
    toolBar.textAlignment = View.TEXT_ALIGNMENT_CENTER
    toolBar.setBackgroundColor(Color.LTGRAY)
    toolBar.setTitleTextColor(Color.BLACK)
    toolBar.layoutParams = RelativeLayout.LayoutParams(displaySize.x, 44.dp)
    relativeLayout.addView(toolBar)
    setSupportActionBar(toolBar)
    supportActionBar?.setDisplayHomeAsUpEnabled(true)
    supportActionBar?.setHomeButtonEnabled(true)

    // ad
    MobileAds.initialize(this, AdSettings.appID)
    val adView = AdView(this)
    adView.adSize = AdSize.BANNER
    adView.adUnitId = AdSettings.unitID
    val adViewLP = RelativeLayout.LayoutParams(320.dp, 50.dp)
    adViewLP.addRule(RelativeLayout.CENTER_HORIZONTAL)
    adViewLP.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM)
    adView.layoutParams = adViewLP
    relativeLayout.addView(adView)
    val adRequest = AdRequest.Builder().build()
    adView.loadAd(adRequest)

    // list view
    val listView = ListView(this)
    val jsonStr = this.getSharedPreferences("saveData", Context.MODE_PRIVATE).getString(category, "")
    val listType = object: TypeToken<ArrayList<Item>>(){}.type
    items = gson.fromJson(jsonStr, listType) ?: arrayListOf()
    adapter = ContentAdapter(this@ContentActivity, items, category)
    listView.adapter = adapter
    listView.divider = ColorDrawable(Color.LTGRAY)
    listView.dividerHeight = 1.dp
    val listViewLP = RelativeLayout.LayoutParams(displaySize.x, displaySize.y - 119.dp)
    listViewLP.topMargin = 44.dp
    listView.layoutParams = listViewLP
    relativeLayout.addView(listView)

    listView.setOnItemLongClickListener { parent, view, position, id ->
      AlertDialog.Builder(this)
          .setTitle("Delete Contents")
          .setMessage("Delete this contents?")
          .setPositiveButton("Delete", DialogInterface.OnClickListener { dialog, which ->
            items.removeAt(position)
            this.getSharedPreferences("saveData", Context.MODE_PRIVATE).edit().putString(category, gson.toJson(items)).apply()
            adapter.notifyDataSetChanged()
          })
          .setNegativeButton("Cancel", null)
          .show()
      return@setOnItemLongClickListener true
    }
  }

  override fun onCreateOptionsMenu(menu: Menu?): Boolean {
    menuInflater.inflate(R.menu.category, menu)
    return true
  }

  override fun onOptionsItemSelected(item: MenuItem?): Boolean {
    val id = item?.itemId
    when (id) {
      R.id.action_add -> {
        val editView = EditText(this)
        AlertDialog.Builder(this)
            .setTitle("New Contents")
            .setMessage("Enter a name for this contents.")
            .setView(editView)
            .setPositiveButton("Save", DialogInterface.OnClickListener { dialog, which ->
              var item = Item(editView.text.toString(), 0.toString())
              items.add(item)
              this.getSharedPreferences("saveData", Context.MODE_PRIVATE).edit().putString(category, gson.toJson(items)).apply()
              adapter.notifyDataSetChanged()
            })
            .setNegativeButton("Cancel", null)
            .show()
      }
      android.R.id.home -> {
        finish()
      }
    }
    return true
  }

  private fun getDisplaySize(activity: Activity): Point {
    val display = activity.windowManager.defaultDisplay
    val point = Point()
    display.getSize(point)
    return point
  }
}