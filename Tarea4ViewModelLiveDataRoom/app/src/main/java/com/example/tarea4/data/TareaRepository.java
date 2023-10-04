package com.example.tarea4.data;
import java.util.List;

import android.app.Application;
import android.os.AsyncTask;
import androidx.lifecycle.LiveData;
import com.example.tarea4.entities.Tarea;

public class TareaRepository {
    private TareaDao mTareaDao;
    private LiveData<List<Tarea>> mAllTareas;

    TareaRepository(Application application) {
        TareaRoomDatabase db = TareaRoomDatabase.getDatabase(application);
        mTareaDao = db.tareaDao();
        mAllTareas = mTareaDao.getAllTareas();
    }

    LiveData<List<Tarea>> getAllTareas() {
        return mAllTareas;
    }

    void insert(Tarea tarea) {
        TareaRoomDatabase.databaseWriteExecutor.execute(() -> {
            mTareaDao.insert(tarea);
        });
    }

    void updateStatus(int id) {
        TareaRoomDatabase.databaseWriteExecutor.execute(() -> {
            mTareaDao.updateStatus(id);
        });
    }

    void deleteById(int id) {
        TareaRoomDatabase.databaseWriteExecutor.execute(() -> {
            mTareaDao.deleteById(id);
        });
    }

    void updateTask(String task, int id) {
        TareaRoomDatabase.databaseWriteExecutor.execute(() -> {
            mTareaDao.updateTask(task, id);
        });
    }
}
