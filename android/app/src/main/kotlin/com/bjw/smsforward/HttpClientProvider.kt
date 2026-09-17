package com.bjw.smsforward

import okhttp3.OkHttpClient

object HttpClientProvider {
    val client: OkHttpClient by lazy { OkHttpClient() }
}