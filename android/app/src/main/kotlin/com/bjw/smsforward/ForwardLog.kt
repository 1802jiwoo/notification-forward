package com.bjw.smsforward

import androidx.room3.Entity
import androidx.room3.PrimaryKey

@Entity(tableName = "forward_logs")
data class ForwardLog(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val packageName: String,
    val timestamp: Long,
    val title: String?,
    val filterName: String,
    val channelType: String,
    val success: Boolean
)