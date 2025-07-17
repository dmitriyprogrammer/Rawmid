package com.rawmid.rawmid

import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setApiKey("7f25bf9c-384c-472b-a08a-4d4b0ea07c0b")
    }
}