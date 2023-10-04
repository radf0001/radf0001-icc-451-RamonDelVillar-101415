package com.example.tarea4.data;

import androidx.lifecycle.LiveData;
import androidx.room.*;
import com.example.tarea4.entities.Tarea;

import java.util.List;

@Dao
public interface TareaDao {

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    void insert(Tarea tarea);


    @Query("UPDATE tarea_table SET status = NOT status WHERE id = :id")
    void updateStatus(int id);

    @Query("UPDATE tarea_table SET task = :task WHERE id = :id")
    void updateTask(String task, int id);

    @Query("DELETE FROM tarea_table")
    void deleteAll();

    @Query("DELETE FROM tarea_table WHERE id = :id")
    void deleteById(int id);

    @Query("SELECT * from tarea_table ORDER BY task ASC")
    LiveData<List<Tarea>> getAllTareas();
}
