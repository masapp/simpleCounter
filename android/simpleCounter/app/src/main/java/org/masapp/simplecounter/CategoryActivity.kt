package org.masapp.simplecounter

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.graphics.Color
import android.graphics.Point
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.Menu
import android.view.View
import android.widget.ListView
import android.widget.RelativeLayout
import android.support.v7.widget.Toolbar
import android.view.MenuItem
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.MobileAds
import org.masapp.simplecounter.Constant.AdSettings
import org.masapp.simplecounter.Extension.SharedPreference
import org.masapp.simplecounter.Extension.dp
import android.content.DialogInterface
import android.content.Intent
import android.graphics.drawable.ColorDrawable
import android.widget.EditText
import org.masapp.simplecounter.Adapter.CategoryAdapter

/**
 * Created by masapp on 2018/04/23.
 */
class CategoryActivity : AppCompatActivity() {

  lateinit var items: ArrayList<String>
  lateinit var adapter: CategoryAdapter

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_category)

    val displaySize = getDisplaySize(this)
    val relativeLayout = findViewById(R.id.categoryLayout) as RelativeLayout

    // background
    val background = View(this)
    background.setBackgroundColor(Color.WHITE)
    val backgroundLP = RelativeLayout.LayoutParams(displaySize.x, displaySize.y)
    backgroundLP.addRule(RelativeLayout.ALIGN_PARENT_TOP)
    background.layoutParams = backgroundLP
    relativeLayout.addView(background)

    // toolbar
    val toolBar = Toolbar(this)
    toolBar.title = "Category"
    toolBar.textAlignment = View.TEXT_ALIGNMENT_CENTER
    toolBar.setBackgroundColor(Color.LTGRAY)
    toolBar.setTitleTextColor(Color.BLACK)
    toolBar.layoutParams = RelativeLayout.LayoutParams(displaySize.x, 44.dp)
    relativeLayout.addView(toolBar)
    setSupportActionBar(toolBar)

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
    items = SharedPreference(this@CategoryActivity).loadArrayList("category")
    adapter = CategoryAdapter(this@CategoryActivity, items)
    listView.adapter = adapter
    listView.divider = ColorDrawable(Color.LTGRAY)
    listView.dividerHeight = 1.dp
    val listViewLP = RelativeLayout.LayoutParams(displaySize.x, displaySize.y - 119.dp)
    listViewLP.topMargin = 44.dp
    listView.layoutParams = listViewLP
    relativeLayout.addView(listView)

    listView.setOnItemClickListener { parent, view, position, id ->
      val item = adapter.getItem(position)
      val intent = Intent(this, ContentActivity::class.java)
      intent.putExtra("TITLE", item.toString())
      startActivity(intent)
    }

    listView.setOnItemLongClickListener { parent, view, position, id ->
      AlertDialog.Builder(this)
          .setTitle("Delete Category")
          .setMessage("Delete this category?")
          .setPositiveButton("Delete", DialogInterface.OnClickListener { dialog, which ->
            System.out.println(this.getPreferences(Context.MODE_PRIVATE).getString(items[position], ""))
            this.getSharedPreferences("saveData", Context.MODE_PRIVATE).edit().remove(items[position]).apply()
            items.removeAt(position)
            SharedPreference(this@CategoryActivity).saveArrayList("category", items)
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
    if (id == R.id.action_add) {
      val editView = EditText(this)
      AlertDialog.Builder(this)
          .setTitle("New Category")
          .setMessage("Enter a name for this category.")
          .setView(editView)
          .setPositiveButton("Save", DialogInterface.OnClickListener { dialog, which ->
            items.add(editView.text.toString())
            SharedPreference(this@CategoryActivity).saveArrayList("category", items)
            adapter.notifyDataSetChanged()
          })
          .setNegativeButton("Cancel", null)
          .show()
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
