package com.bjw.smsforward

import android.content.Context
import androidx.room3.Database
import androidx.room3.Room
import androidx.room3.RoomDatabase

@Database(entities = [ForwardLog::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun forwardLogDao(): ForwardLogDao

    companion object {
        @Volatile private var INSTANCE: AppDatabase? = null
        fun getInstance(context: Context): AppDatabase =
            INSTANCE ?: synchronized(this) { // 한번에 스레드만 실행가능
                // 위에서 순서가 밀린 경우 앞에 저장된 값 반환
                INSTANCE ?: Room.databaseBuilder(
                    context.applicationContext, AppDatabase::class.java, "smsforward.db"
                ).build().also { INSTANCE = it }
            }
    }
}