package com.bjw.smsforward

import androidx.room3.Dao
import androidx.room3.Insert
import androidx.room3.Query

@Dao
interface ForwardLogDao {
    @Insert
    suspend fun insert(log: ForwardLog)

    @Query("SELECT * FROM forward_logs ORDER BY timestamp DESC")
    suspend fun getAll(): List<ForwardLog>

    @Query("DELETE FROM forward_logs WHERE id NOT IN (SELECT id FROM forward_logs ORDER BY timestamp DESC LIMIT :keep)")
    suspend fun trimTo(keep: Int)
}