package com.orbitai.ags_ims

import io.flutter.embedding.android.FlutterActivity
import io.flutter.app.FlutterApplication
import android.content.Context
import androidx.multidex.MultiDex

class MainActivity: FlutterActivity() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}
